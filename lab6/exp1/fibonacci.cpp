#include <iostream>
#include <vector>
#include <chrono>

using namespace std;

long fibonacci(int n, vector<long>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo);
    return memo[n];
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <n>" << endl;
        return 1;
    }
    
    int n = stoi(argv[1]);
    vector<long> memo(n+1, -1);
    
    auto start = chrono::high_resolution_clock::now();
    long result = fibonacci(n, memo);
    auto end = chrono::high_resolution_clock::now();
    
    cout << "Fibonacci(" << n << ") = " << result << endl;
    
    auto duration = chrono::duration_cast<chrono::milliseconds>(end - start);
    cerr << "Time: " << duration.count() << " ms" << endl;
    
    return 0;
}