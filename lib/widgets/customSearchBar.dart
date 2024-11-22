import 'package:flutter/material.dart';
 class customSearchBar extends StatelessWidget {
   const customSearchBar({super.key});

   @override
   Widget build(BuildContext context) {
     return Material(
       elevation: 5,
       shadowColor: const Color(0XFF000000),
       borderRadius: BorderRadius.circular(20.0),
       child: TextField(
         decoration: InputDecoration(
           hintText: 'Search...',
           hintStyle: const TextStyle(color: Colors.black54),
           prefixIcon: Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: const Icon(
                   Icons.search,
                   color: Colors.black54,
                 ),
               ),
               Container(
                 height: 24,
                 width: 2,
                 color: Colors.black54,
               ),
               const SizedBox(width: 8),
             ],
           ),
           suffixIcon: const Icon(Icons.mic, color: Colors.black54,),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(20.0),
             borderSide: BorderSide.none,
           ),
           filled: true,
           fillColor: Colors.white,
         ),
         onChanged: (value) {
           // Logic for searching to be implemented
         },
       ),
     );
   }
 }
