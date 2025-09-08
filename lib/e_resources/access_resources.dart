import 'package:flutter/material.dart';
import '../assets.dart';
import 'package:url_launcher/url_launcher.dart';

class AccessResources extends StatelessWidget {
  const AccessResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
            // or Navigator.pushNamed(context, '/homepage');
          },
        ),
        title: const Text(
          'Name of Resourc',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
           Center(
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Anya.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
           ),
            const SizedBox(height: 16),
           Center(
            child: InkWell(
              onTap: () {
                launchUrl(Uri.parse("https://login.ebsco.com/?requestIdentifier=e6932a19-55ce-4b9a-aef3-6d582210a8e0&acrValues=uid&ui_locales&redirect_uri=https://logon.ebsco.zone/api/dispatcher/continue/prompted?state=MzQzYWM1NGVjY2MyNDJlZmJlODhlY2NiY2MwNGUxYTU=&authRequest=eyJraWQiOiIxNjg2MTQ5MjEzNjMxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczpcL1wvYXV0aC5lYnNjby56b25lXC9hcGlcL2Rpc3BhdGNoZXIiLCJhdXRoUmVxdWVzdCI6eyJsb2dpbl9oaW50IjpudWxsLCJncmFudF90eXBlIjoiYXV0aG9yaXphdGlvbl9jb2RlIiwic2NvcGUiOiJvcGVuaWQgZW1haWwgYWZmaWxpYXRpb24iLCJhY3JfdmFsdWVzIjoidWlkIiwicmVzcG9uc2VfdHlwZSI6ImNvZGUiLCJyZWRpcmVjdF91cmkiOiJodHRwczpcL1wvc2VhcmNoLmVic2NvaG9zdC5jb21cL3dlYmF1dGhcL1Byb21wdGVkQ2FsbGJhY2suYXNweCIsInN0YXRlIjoiQXdvQ2tCeWhCSE94bWxuc3c0UlJ2SnpOVGFfWDR3ZzZvc2p0ODRFV1lCM19JcG5EQjZJLS0xdk9iV2NvUkxyMVRGWGJwb0ZDU3ppbXh2QmEzX2pQU0I2LUpJOXFHR1FNdExGc19RMzllTWFrVUJDaXc2Um9IRVU3RDFRTUNsS1ZfVG5pbVVwOHE1VDBKNjdGVUlqY2dZWVpkeXBrblpRTW9kYkRuSjhLNjU2b29BRTQ2cm9VYm5RelJId0JnelFjQllkRWg0cTZpeTducDZUWTNoRWZ0TTJKWEFkQUVkcGRFcEtFVmpiQzhudnIzU2tEVW9qWHlHRlRGUGVoeVhBMzd0RTRraEFHSnJ4VXFRLUdNaTlQdDdfWjdyWnY4ZTRjZjk3MENhSUV1cWRtMHV0eXBsc3dWbUhRMjFNRWFYVHZlSGdIUGczRXotV1VncDdMbzlzeXh0Q09QaTE4bWNqNXpSOWVxRWpzT2VLdjhuTjdGc00iLCJjbGllbnRfaWQiOiJhd2d5Y0l4NTdNcnduRFE1aDRVZTZ5Q1ZFUDByNU10OSIsInJlc3BvbnNlX21vZGUiOiJxdWVyeSIsInJlcUlkIjoiZTY5MzJhMTktNTVjZS00YjlhLWFlZjMtNmQ1ODIyMTBhOGUwIn0sImlhdCI6MTc1NzAzNzAyMSwianRpIjoiMTA0YTRmYzktNzY5OS00OTNhLThlM2UtMGEzYzhlNmNmMzAzIiwicmVxSWQiOiJlNjkzMmExOS01NWNlLTRiOWEtYWVmMy02ZDU4MjIxMGE4ZTAifQ.AFy8IT4D6mQAQzdhjH0E0rYlQhEqYLDz2SlhVno3yUnE5tkoM0CpyjhUaMm2O8qRgX67wJ7u49aFrBMoXe-6kG0S_SrDiZ9sbc58VIoi8lzdWiXJWiiUSJ1jOB3iVBr-b_3oOXdKaOIcb3y0-jaOYVBEEmqQRbRxOnzgWS9JKM_LdKkRyES_m8koQD98pNftC1dNGMC6I_RgzIykyMRjHQzTn1OsoIH8tykbKQIl7xZsKupvz0HQcmDu8XApuJYbG2LDw28ou1CFN0VTRFwarR3I6sGvJtI_sUDfp9tcXuoVpGjD1dw1AqCw1r12PXq3oTfbRVwFtTmVatJ0B43lJA"));
              },
             child: Text(
              "LInk Here",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryGreen,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic
              ),
            ),
            ),
           ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textColor,
                  width: 2
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                  padding: const EdgeInsets.all(12),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor, // or AppColors.textColor
                      ),
                      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                          "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                          "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
                          "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
