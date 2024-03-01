// InkWell(
//                   onTap: () => _selectedLoginNotifier.value =
//                       !_selectedLoginNotifier.value,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 50, vertical: 10),
//                     decoration: BoxDecoration(
//                         color: const Color(0xFF5063A3),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Stack(
//                       children: [
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Text(
//                                 'Student',
//                                 style: TextStyle(
//                                     color: Color(0xFFF1F1F1),
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w800
// 								),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Text(
//                                 'Teacher',
//                                 style: TextStyle(
//                                     color: Color(0xFFF1F1F1),
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w800),
//                               ),
//                             ),
//                           ],
//                         ),
//                         ValueListenableBuilder(
//                           valueListenable: _selectedLoginNotifier,
//                           builder: (context, value, child) {
//                             return AnimatedPositioned(
//                                 left: value
//                                     ? 0
//                                     : (MediaQuery.of(context).size.width / 2) -
//                                         95,
//                                 duration: const Duration(milliseconds: 250),
//                                 child: Container(
//                                   width:
//                                       (MediaQuery.of(context).size.width / 2) -
//                                           75,
//                                   decoration: BoxDecoration(
//                                       color: Colors.deepPurpleAccent,
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: Text(
//                                       value ? 'Student' : 'Teacher',
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                   ),
//                                 ));
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ),