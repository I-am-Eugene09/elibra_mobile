import 'package:flutter/material.dart';
import '../assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AccessResources extends StatelessWidget {
  const AccessResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'EBSO RESOURCE',
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
           // Header card (consistent with other screens)
           Container(
             padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
               color: AppColors.primaryGreen.withOpacity(0.05),
               borderRadius: BorderRadius.circular(16),
             ),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                   child: Image.asset(
                     'assets/images/Anya.jpg',
                     width: 90,
                     height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                 const SizedBox(width: 14),
                 const Expanded(
             child: Text(
                     'You are about to open this licensed resource in your browser. Use your valid access to continue.',
              style: TextStyle(
                       fontSize: 12,
                       color: Colors.black87,
                     ),
                   ),
                 ),
               ],
            ),
           ),
            const SizedBox(height: 24),

           // Horizontal cards: Open Resource + Credentials
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 6),
              children: [
                // Open Resource card
            Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen.withOpacity(0.08),
                        AppColors.primaryGreen.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.open_in_browser, color: AppColors.primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Open Resource',
                    style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                      color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.4)),
                            ),
                            onPressed: () async {
                              final uri = Uri.parse('https://login.ebsco.com/?requestIdentifier=e6932a19-55ce-4b9a-aef3-6d582210a8e0&acrValues=uid&ui_locales&redirect_uri=https://logon.ebsco.zone/api/dispatcher/continue/prompted?state=MzQzYWM1NGVjY2MyNDJlZmJlODhlY2NiY2MwNGUxYTU=&authRequest=eyJraWQiOiIxNjg2MTQ5MjEzNjMxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczpcL1wvYXV0aC5lYnNjby56b25lXC9hcGlcL2Rpc3BhdGNoZXIiLCJhdXRoUmVxdWVzdCI6eyJsb2dpbl9oaW50IjpudWxsLCJncmFudF90eXBlIjoiYXV0aG9yaXphdGlvbl9jb2RlIiwic2NvcGUiOiJvcGVuaWQgZW1haWwgYWZmaWxpYXRpb24iLCJhY3JfdmFsdWVzIjoidWlkIiwicmVzcG9uc2VfdHlwZSI6ImNvZGUiLCJyZWRpcmVjdF91cmkiOiJodHRwczpcL1wvc2VhcmNoLmVic2NvaG9zdC5jb21cL3dlYmF1dGhcL1Byb21wdGVkQ2FsbGJhY2suYXNweCIsInN0YXRlIjoiQXdvQ2tCeWhCSE94bWxuc3c0UlJ2SnpOVGFfWDR3ZzZvc2p0ODRFV1lCM19JcG5EQjZJLS0xdk9iV2NvUkxyMVRGWGJwb0ZDU3ppbXh2QmEzX2pQU0I2LUpJOXFHR1FNdExGc19RMzllTWFrVUJDaXc2Um9IRVU3RDFRTUNsS1ZfVG5pbVVwOHE1VDBKNjdGVUlqY2dZWVpkeXBrblpRTW9kYkRuSjhLNjU2b29BRTQ2cm9VYm5RelJId0JnelFjQllkRWg0cTZpeTducDZUWTNoRWZ0TTJKWEFkQUVkcGRFcEtFVmpiQzhudnIzU2tEVW9qWHlHRlRGUGVoeVhBMzd0RTRraEFHSnJ4VXFRLUdNaTlQdDdfWjdyWnY4ZTRjZjk3MENhSUV1cWRtMHV0eXBsc3dWbUhRMjFNRWFYVHZlSGdIUGczRXotV1VncDdMbzlzeXh0Q09QaTE4bWNqNXpSOWVxRWpzT2VLdjhuTjdGc00iLCJjbGllbnRfaWQiOiJhd2d5Y0l4NTdNcnduRFE1aDRVZTZ5Q1ZFUDByNU10OSIsInJlc3BvbnNlX21vZGUiOiJxdWVyeSIsInJlcUlkIjoiZTY5MzJhMTktNTVjZS00YjlhLWFlZjMtNmQ1ODIyMTBhOGUwIn0sImlhdCI6MTc1NzAzNzAyMSwianRpIjoiMTA0YTRmYzktNzY5OS00OTNhLThlM2UtMGEzYzhlNmNmMzAzIiwicmVxSWQiOiJlNjkzMmExOS01NWNlLTRiOWEtYWVmMy02ZDU4MjIxMGE4ZTAifQ.AFy8IT4D6mQAQzdhjH0E0rYlQhEqYLDz2SlhVno3yUnE5tkoM0CpyjhUaMm2O8qRgX67wJ7u49aFrBMoXe-6kG0S_SrDiZ9sbc58VIoi8lzdWiXJWiiUSJ1jOB3iVBr-b_3oOXdKaOIcb3y0-jaOYVBEEmqQRbRxOnzgWS9JKM_LdKkRyES_m8koQD98pNftC1dNGMC6I_RgzIykyMRjHQzTn1OsoIH8tykbKQIl7xZsKupvz0HQcmDu8XApuJYbG2LDw28ou1CFN0VTRFwarR3I6sGvJtI_sUDfp9tcXuoVpGjD1dw1AqCw1r12PXq3oTfbRVwFtTmVatJ0B43lJA');
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            },
                            child: const Text(
                              'Open in browser',
                              style: TextStyle( color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Credentials card
                Container(
                  width: 310,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen.withOpacity(0.08),
                        AppColors.primaryGreen.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.lock_open, color: AppColors.primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Credentials',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _credentialRow(context, label: 'Username', value: 'isu_user'),
                        const SizedBox(height: 6),
                        _credentialRow(context, label: 'Password', value: 'isu_pass'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

           const SizedBox(height: 24),

           // Description card
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
                 colors: [
                   AppColors.primaryGreen.withOpacity(0.08),
                   AppColors.primaryGreen.withOpacity(0.03),
                 ],
               ),
               borderRadius: BorderRadius.circular(16),
               border: Border.all(
                 color: AppColors.primaryGreen.withOpacity(0.1),
               ),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start, 
               children: const [
                 Text(
                   "Description",
                   style: TextStyle(
                     fontSize: 16,
                     color: AppColors.primaryGreen,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(height: 8),
                 Text(
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                   textAlign: TextAlign.justify,
                   style: TextStyle(
                     fontSize: 14,
                     color: AppColors.textColor,
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

  Widget _credentialRow(BuildContext context, {required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textColor, fontSize: 13),
            ),
          ),
          IconButton(
            tooltip: 'Copy',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.copy, size: 18, color: AppColors.primaryGreen),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label copied to clipboard')),
              );
            },
          ),
        ],
      ),
    );
  }
}
