import 'package:flutter/material.dart';

class TermsAndPoliciesPage extends StatelessWidget {
  const TermsAndPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Policies'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Policies',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last updated: 31st February, 2025',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('1. Contractual Relationship'),
            _buildSectionText(
                'These Terms of Use (“Terms”) govern the access or use by you, an individual, from within any country in the world (excluding the United States and its territories and possessions and Mainland China) of applications, websites, content, products, and services (the “Services”) made available by Uber B.V., a private limited liability company established in the Netherlands, having its offices at Burgerweeshuispad 301, 1076 HR Amsterdam, Netherlands, registered at the Amsterdam Chamber of Commerce under number 56317441 (“Uber”).'),
            _buildSectionText(
                'PLEASE READ THESE TERMS CAREFULLY BEFORE ACCESSING OR USING THE SERVICES.'),
            _buildSectionText(
                'Your access and use of the Services constitutes your agreement to be bound by these Terms, which establishes a contractual relationship between you and Uber. If you do not agree to these Terms, you may not access or use the Services. These Terms expressly supersede prior agreements or arrangements with you. Uber may immediately terminate these Terms or any Services with respect to you, or generally cease offering or deny access to the Services or any portion thereof, at any time for any reason.'),
            _buildSectionText(
                'Supplemental terms may apply to certain Services, such as policies for a particular event, activity or promotion, and such supplemental terms will be disclosed to you in connection with the applicable Services. Supplemental terms are in addition to, and shall be deemed a part of, the Terms for the purposes of the applicable Services. Supplemental terms shall prevail over these Terms in the event of a conflict with respect to the applicable Services.'),
            _buildSectionText(
                'Uber may amend the Terms related to the Services from time to time. Amendments will be effective upon Uber’s posting of such updated Terms at this location or the amended policies or supplemental terms on the applicable Service. Your continued access or use of the Services after such posting constitutes your consent to be bound by the Terms, as amended.'),
            _buildSectionText(
                'Our collection and use of personal information in connection with the Services is as provided in Uber’s Privacy Policy located at https://www.uber.com/privacy/notice. Uber may provide to a claims processor or an insurer any necessary information (including your contact information) if there is a complaint, dispute or conflict, which may include an accident, involving you and a Third Party Provider (including a transportation network company driver) and such information or data is necessary to resolve the complaint, dispute or conflict.'),
            const SizedBox(height: 20),
            _buildSectionTitle('2. The Services'),
            _buildSectionText(
                'The Services constitute a technology platform that enables users of Uber’s mobile applications or websites provided as part of the Services (each, an “Application”) to arrange and schedule transportation and/or logistics services with independent third party providers of such services, including independent third party transportation providers and independent third party logistics providers under agreement with Uber or certain of Uber’s affiliates (“Third Party Providers”). Unless otherwise agreed by Uber in a separate written agreement with you, the Services are made available solely for your personal, noncommercial use. YOU ACKNOWLEDGE THAT UBER DOES NOT PROVIDE TRANSPORTATION OR LOGISTICS SERVICES OR FUNCTION AS A TRANSPORTATION CARRIER AND THAT ALL SUCH TRANSPORTATION OR LOGISTICS SERVICES ARE PROVIDED BY INDEPENDENT THIRD PARTY CONTRACTORS WHO ARE NOT EMPLOYED BY UBER OR ANY OF ITS AFFILIATES.'),
            _buildSectionTitle('License.'),
            _buildSectionText(
                'Subject to your compliance with these Terms, Uber grants you a limited, non-exclusive, non-sublicensable, revocable, non-transferrable license to: (i) access and use the Applications on your personal device solely in connection with your use of the Services; and (ii) access and use any content, information and related materials that may be made available through the Services, in each case solely for your personal, noncommercial use. Any rights not expressly granted herein are reserved by Uber and Uber’s licensors.'),
            _buildSectionTitle('Restrictions.'),
            _buildSectionText(
                'You may not: (i) remove any copyright, trademark or other proprietary notices from any portion of the Services; (ii) reproduce, modify, prepare derivative works based upon, distribute, license, lease, sell, resell, transfer, publicly display, publicly perform, transmit, stream, broadcast or otherwise exploit the Services except as expressly permitted by Uber; (iii) decompile, reverse engineer or disassemble the Services except as may be permitted by applicable law; (iv) link to, mirror or frame any portion of the Services; (v) cause or launch any programs or scripts for the purpose of scraping, indexing, surveying, or otherwise data mining any portion of the Services or unduly burdening or hindering the operation and/or functionality of any aspect of the Services; or (vi) attempt to gain unauthorized access to or impair any aspect of the Services or its related systems or networks.'),
            _buildSectionTitle('Provision of the Services.'),
            _buildSectionText(
                'You acknowledge that portions of the Services may be made available under Uber’s various brands or request options associated with transportation or logistics, including the transportation request brands currently referred to as “Uber,” “uberPOP,” “uberX,” “uberXL,” “UberBLACK,” “UberSUV,” “UberBERLINE,” “UberVAN,” “UberEXEC,” and “UberLUX” and the logistics request brands currently referred to as “UberRUSH,” “UberFRESH” and “UberEATS”. You also acknowledge that the Services may be made available under such brands or request options by or in connection with: (i) certain of Uber’s subsidiaries and affiliates; or (ii) independent Third Party Providers, including transportation network company drivers, transportation charter permit holders or holders of similar transportation permits, authorizations or licenses.'),
            _buildSectionTitle('Third Party Services and Content.'),
            _buildSectionText(
                'The Services may be made available or accessed in connection with third party services and content (including advertising) that Uber does not control. You acknowledge that different terms of use and privacy policies may apply to your use of such third party services and content. Uber does not endorse such third party services and content and in no event shall Uber be responsible or liable for any products or services of such third party providers. Additionally, Apple Inc., Google, Inc., Microsoft Corporation or BlackBerry Limited and/or their applicable international subsidiaries and affiliates will be third-party beneficiaries to this contract if you access the Services using Applications developed for Apple iOS, Android, Microsoft Windows, or Blackberry-powered mobile devices, respectively. These third party beneficiaries are not parties to this contract and are not responsible for the provision or support of the Services in any manner. Your access to the Services using these devices is subject to terms set forth in the applicable third party beneficiary’s terms of service.'),
            _buildSectionTitle('Ownership.'),
            _buildSectionText(
                'The Services and all rights therein are and shall remain Uber’s property or the property of Uber’s licensors. Neither these Terms nor your use of the Services convey or grant to you any rights: (i) in or related to the Services except for the limited license granted above; or (ii) to use or reference in any manner Uber’s company names, logos, product and service names, trademarks or services marks or those of Uber’s licensors.'),
            // Add more sections as needed...
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}
// terms_and_policies.dart

/*import 'package:flutter/material.dart';

void main() {
  runApp(TermsAndPoliciesPage());
}

class TermsAndPoliciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terms and Policies',
      home: TermsAndPoliciesScreen(),
    );
  }
}

class TermsAndPoliciesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: December 4th, 2017',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Contractual Relationship\n'
                    'These Terms of Use (“Terms”) govern the access or use by you, an individual, from within any country in the world (excluding the United States and its territories and possessions and Mainland China) of applications, websites, content, products, and services (the “Services”) made available by Uber B.V., a private limited liability company established in the Netherlands, having its offices at Burgerweeshuispad 301, 1076 HR Amsterdam, Netherlands, registered at the Amsterdam Chamber of Commerce under number 56317441 (“Uber”).\n\n'
                    'PLEASE READ THESE TERMS CAREFULLY BEFORE ACCESSING OR USING THE SERVICES.\n\n'
                    'Your access and use of the Services constitutes your agreement to be bound by these Terms, which establishes a contractual relationship between you and Uber. If you do not agree to these Terms, you may not access or use the Services. These Terms expressly supersede prior agreements or arrangements with you. Uber may immediately terminate these Terms or any Services with respect to you, or generally cease offering or deny access to the Services or any portion thereof, at any time for any reason.\n\n'
                    'Supplemental terms may apply to certain Services, such as policies for a particular event, activity or promotion, and such supplemental terms will be disclosed to you in connection with the applicable Services. Supplemental terms are in addition to, and shall be deemed a part of, the Terms for the purposes of the applicable Services. Supplemental terms shall prevail over these Terms in the event of a conflict with respect to the applicable Services.\n\n'
                    'Uber may amend the Terms related to the Services from time to time. Amendments will be effective upon Uber’s posting of such updated Terms at this location or the amended policies or supplemental terms on the applicable Service. Your continued access or use of the Services after such posting constitutes your consent to be bound by the Terms, as amended.\n\n'
                    'Our collection and use of personal information in connection with the Services is as provided in Uber’s Privacy Policy located at https://www.uber.com/privacy/notice. Uber may provide to a claims processor or an insurer any necessary information (including your contact information) if there is a complaint, dispute or conflict, which may include an accident, involving you and a Third Party Provider (including a transportation network company driver) and such information or data is necessary to resolve the complaint, dispute or conflict.\n\n'
                    '2. The Services\n'
                    'The Services constitute a technology platform that enables users of Uber’s mobile applications or websites provided as part of the Services (each, an “Application”) to arrange and schedule transportation and/or logistics services with independent third party providers of such services, including independent third party transportation providers and independent third party logistics providers under agreement with Uber or certain of Uber’s affiliates (“Third Party Providers”). Unless otherwise agreed by Uber in a separate written agreement with you, the Services are made available solely for your personal, noncommercial use. YOU ACKNOWLEDGE THAT UBER DOES NOT PROVIDE TRANSPORTATION OR LOGISTICS SERVICES OR FUNCTION AS A TRANSPORTATION CARRIER AND THAT ALL SUCH TRANSPORTATION OR LOGISTICS SERVICES ARE PROVIDED BY INDEPENDENT THIRD PARTY CONTRACTORS WHO ARE NOT EMPLOYED BY UBER OR ANY OF ITS AFFILIATES.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/