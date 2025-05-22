#include <iostream>
#include <fstream>
#include <chrono>

void process_file(const std::string& filename) {
    std::fstream file(filename, std::ios::in | std::ios::out | std::ios::binary);
    if (!file) {
        std::cerr << "Cannot open file: " << filename << std::endl;
        return;
    }

    int num;
    while (file.read(reinterpret_cast<char*>(&num), sizeof(int))) {
        num *= 2; 
        file.seekp(-sizeof(int), std::ios::cur); 
        file.write(reinterpret_cast<const char*>(&num), sizeof(int));
        file.flush();  
    }
    file.close();
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <filename>" << std::endl;
        return 1;
    }

    auto start = std::chrono::high_resolution_clock::now();
    process_file(argv[1]);
    auto end = std::chrono::high_resolution_clock::now();

    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    std::cerr << "Time: " << duration.count() << " ms" << std::endl;

    return 0;
}