#include "string"
#include "dlfcn.h"
#include <filesystem>
#include <iostream>

extern "C" void playAudio(const char* filePath) {
  std::cout << "Attempting to play: " << filePath << std::endl;
  std::filesystem::path file{filePath};

  if (std::filesystem::exists(file)) {
    std::cout << "File exists" << std::endl;
  } else {
    std::cout << "File does not exist" << std::endl;
    return;
  }

  void* handle = dlopen("/Users/Salman/Projects/Prototypes/FastZip/Assets/OSPort.dylib", RTLD_LAZY);
  if (!handle) {
    std::cout << "Unable to load dylib: " << dlerror() << std::endl;
    return;
  }

  void (*playAudioFunc)(const char*) = (void (*)(const char*))dlsym(handle, "av_playAudio");
  if (!playAudioFunc) {
    std::cout << "Unable to find symbol: " << dlerror() << std::endl;
    dlclose(handle);
    return;
  }

  playAudioFunc(filePath);
  dlclose(handle);
}


