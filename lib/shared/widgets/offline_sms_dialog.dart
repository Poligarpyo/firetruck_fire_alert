// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../constants/app_colors.dart';
// import '../features/offline_sms/presentation/screen/geolocator/getCurrentLocation.dart';
// import '../features/offline_sms/presentation/screen/telephony/sendEmergencySMS.dart';

// class OfflineSMSReportDialog extends ConsumerStatefulWidget {
//   const OfflineSMSReportDialog({super.key});

//   @override
//   ConsumerState<OfflineSMSReportDialog> createState() =>
//       _OfflineSMSReportDialogState();
// }

// class _OfflineSMSReportDialogState
//     extends ConsumerState<OfflineSMSReportDialog> {
//   final TextEditingController _messageController = TextEditingController();
//   final int maxCharacters = 160;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _handleSendSMS() async {
//     if (_messageController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a message'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     try {
//       final position = await getCurrentLocation();

//       final message =
//           "${_messageController.text}\nLocation: ${position.latitude}, ${position.longitude}";

//       await sendEmergencySMS(message);

//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('SMS report sent to 911'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to send SMS: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _handleCancel() {
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final size = MediaQuery.of(context).size;

//     return Dialog(
//       backgroundColor: Colors.white, // ✅ force white
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxHeight: size.height * 0.9,
//           maxWidth: size.width > 600 ? 500 : size.width,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ✅ HEADER (fixed)
//             _buildHeader(),

//             // ✅ SCROLLABLE CONTENT
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: _buildContent(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.message, color: Colors.white, size: 28),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Text(
//               'Offline SMS Report',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: _handleCancel,
//             icon: const Icon(Icons.close, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Content
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Warning Banner
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFF8E1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xFFFFB74D),
//                     width: 1,
//                   ),
//                 ),
//                 child: const Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: Color(0xFFFF8F00),
//                       size: 24,
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Offline Mode Active',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFFE65100),
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Your report will be sent via SMS to BFP Emergency Hotline. Standard messaging rates may apply.',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Color(0xFFE65100),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),
//               // Phone Number Info
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Your Number:',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.secondaryText,
//                     ),
//                   ),
//                   Text(
//                     'Anonymous',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryText,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // BFP Hotline Info
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'BFP Hotline:',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.secondaryText,
//                     ),
//                   ),
//                   Text(
//                     '911',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryText,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               // Message Label
//               const Text(
//                 'Message to BFP',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryText,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Message Text Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xFFE0E0E0),
//                   ),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   maxLines: 5,
//                   maxLength: maxCharacters,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.primaryText,
//                   ),
//                   decoration: const InputDecoration(
//                     hintText:
//                         'FIRE EMERGENCY: Describe the fire situation, severity, number of people affected, and any obstacles for firefighters...',
//                     hintStyle: TextStyle(
//                       color: AppColors.hintText,
//                       fontSize: 13,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.all(16),
//                     counterText: '',
//                   ),
//                   onChanged: (value) => setState(() {}),
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Character Counter and Info
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'SMS will include: Location + Message',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: AppColors.hintText,
//                     ),
//                   ),
//                   Text(
//                     '${_messageController.text.length}/$maxCharacters',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: _messageController.text.length > maxCharacters
//                           ? Colors.red
//                           : AppColors.hintText,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               // Action Buttons
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final isSmall = constraints.maxWidth < 350;

//                   if (isSmall) {
//                     return Column(
//                       children: [
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _handleSendSMS,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF90A4AE),
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.send, size: 18),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Send SMS Report',
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: OutlinedButton(
//                             onPressed: _handleCancel,
//                             style: OutlinedButton.styleFrom(
//                               side: const BorderSide(
//                                 color: AppColors.borderColor,
//                                 width: 1,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.secondaryText,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }

//                   return Row(
//                     children: [
//                       // Send SMS Button
//                       Expanded(
//                         flex: 2,
//                         child: SizedBox(
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _handleSendSMS,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF90A4AE),
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.send, size: 18),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Send SMS Report',
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 12),

//                       Expanded(
//                         child: SizedBox(
//                           height: 50,
//                           child: OutlinedButton(
//                             onPressed: _handleCancel,
//                             style: OutlinedButton.styleFrom(
//                               side: const BorderSide(
//                                 color: AppColors.borderColor,
//                                 width: 1,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.secondaryText,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Footer Note
//               const Center(
//                 child: Text(
//                   'SMS reports are processed immediately by BFP emergency system',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: AppColors.hintText,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Helper function to show the dialog
// void showOfflineSMSDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) => const OfflineSMSReportDialog(),
//   );
// }
