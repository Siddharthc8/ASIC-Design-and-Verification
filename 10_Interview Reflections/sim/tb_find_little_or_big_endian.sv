`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2025 08:45:51 AM
// Design Name: 
// Module Name: tb_find_little_or_big_endian
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_find_little_or_big_endian();


//#include <iostream>
//using namespace std;

//int main() {
//    unsigned int x = 0x12345678;
//    // Point a char* to x, so it reads the first byte
//    unsigned char *c = (unsigned char*)&x;
//    if (*c == 0x78)
//        cout << "Little-endian" << endl;
//    else if (*c == 0x12)
//        cout << "Big-endian" << endl;
//    else
//        cout << "Unknown endianness" << endl;
//    return 0;
//}

//----------------------------------------------------------------------------------------

//#include <iostream>

//int main() {
//    unsigned int num = 1;
//    char *ptr = (char*)&num;

//    if (*ptr == 1) {
//        std::cout << "Little-endian" << std::endl;
//    } else {
//        std::cout << "Big-endian" << std::endl;
//    }

//    return 0;
//}


/*
This code works by creating an integer variable num with the value 1. 
Then, it creates a character pointer ptr that points to the memory location of num. 
Since a char is one byte, dereferencing ptr will access the first byte of num.
*/