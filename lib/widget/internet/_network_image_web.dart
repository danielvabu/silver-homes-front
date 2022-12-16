// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// The dart:html implementation of [image_provider.NetworkImage].
///
/// NetworkImage on the web does not support decoding to a specified size.
class CustomNetworkImage extends ImageProvider<NetworkImage>
    implements NetworkImage {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  const CustomNetworkImage(this.url, {this.scale = 1.0, this.headers})
      : assert(url != null),
        assert(scale != null);

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String>? headers;

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      chunkEvents: chunkEvents.stream,
      codec: _loadAsync(key as NetworkImage, decode, chunkEvents),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: _imageStreamInformationCollector(key),
    );
  }

  InformationCollector? _imageStreamInformationCollector(NetworkImage key) {
    InformationCollector? collector;
    assert(() {
      collector = () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<NetworkImage>('Image key', key as NetworkImage),
        ];
      };
      return true;
    }());
    return collector;
  }

  // TODO(garyq): We should eventually support custom decoding of network images on Web as
  // well, see https://github.com/flutter/flutter/issues/42789.
  //
  // Web does not support decoding network images to a specified size. The decode parameter
  // here is ignored and the web-only `ui.webOnlyInstantiateImageCodecFromUrl` will be used
  // directly in place of the typical `instantiateImageCodec` method.
  Future<ui.Codec> _loadAsync(
    NetworkImage key,
    DecoderCallback decode,
    StreamController<ImageChunkEvent> chunkEvents,
  ) async {
    assert(key == this);

    final Uri resolved = Uri.base.resolve(key.url);

    final HttpRequest response = await HttpRequest.request(key.url,
        method: 'GET',
        requestHeaders: key.headers,
        responseType: 'arraybuffer');

    if (response.status != HttpStatus.ok) {
      response.abort();
      throw NetworkImageLoadException(
          statusCode: response.status ?? 400, uri: resolved);
    }

    final Uint8List bytes = (response.response as ByteBuffer).asUint8List();

    if (bytes.lengthInBytes == 0)
      throw Exception('NetworkImage is an empty file: $resolved');

    return decode(bytes);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => ui.hashValues(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NetworkImage')}("$url", scale: $scale)';
}
