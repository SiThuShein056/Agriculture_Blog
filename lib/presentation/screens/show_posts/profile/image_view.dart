import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: context.width,
            height: context.height,
            child: Hero(
              tag: url,
              child: InteractiveViewer(
                maxScale: 5.0,
                minScale: 0.01,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator().centered(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline).centered(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: () {
                StarlightUtils.pop();
              },
              icon: const Icon(Icons.close_outlined),
            ),
          )
        ],
      ),
    );
  }
}
