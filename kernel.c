void write(const char *s) {
    volatile char *video = (volatile char*)0xb8000;
    while (*s) {
        *video++ = *s++;
        *video++ = 0x0f;
    }
}

void main() { 
    write("Hello World");
}

