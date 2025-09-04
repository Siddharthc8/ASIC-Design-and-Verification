`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 12:13:47 PM
// Design Name: 
// Module Name: tb_remove_repeating_words
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


module tb_remove_repeating_words();


module tb;
  initial begin
    string s = "this is is a test test string";
    string prev = "", word, result = "";
    int idx = 0;
    
    foreach (s.split(" ", idx, word)) begin
      if (word != prev) result = {result, word, " "};
      prev = word;
    end
    $display("Result: %s", result);
  end

#include <iostream>
#include <sstream>
#include <unordered_set>
#include <vector>
using namespace std;

string remove_repeating_words(const string& sentence) {
    istringstream iss(sentence);
    string word;
    unordered_set<string> seen;
    vector<string> result;
    while (iss >> word) {
        if (seen.find(word) == seen.end()) {
            seen.insert(word);
            result.push_back(word);
        }
    }
    // Build result string
    ostringstream oss;
    for (size_t i = 0; i < result.size(); ++i) {
        if (i > 0) oss << " ";
        oss << result[i];
    }
    return oss.str();
}

int main() {
    string sentence = "this is is a test test sentence sentence";
    cout << remove_repeating_words(sentence) << endl; // Output: "this is a test sentence"
    return 0;
}

endmodule
