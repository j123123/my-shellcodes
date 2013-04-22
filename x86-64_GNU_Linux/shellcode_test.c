#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
 
char shellcode[36];

int main(void)
{
  int fd = open("shellcode_linux_x86-64.bin", O_RDONLY);
  struct stat st;
  fstat(fd, &st);
  off_t size = st.st_size;
  read(fd, shellcode, size);
  (*(void(*)()) shellcode)();
  return 0;
}
