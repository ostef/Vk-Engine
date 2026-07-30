#pragma once

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <clang-c/Index.h>

#ifdef _WIN32
#define DebugBreak() __debugbreak()
#else
#define DebugBreak() __asm volatile("int $0x3")
#endif

#define Assert(x) do { if (!(x)) { printf("Assertion failed at file %s:%d: %s\n", __FILE__, uint32_t(__LINE__), #x); DebugBreak();  } } while(0)

void Error(const char *fmt, ...);
void ErrorExit(const char *fmt, ...);

struct String {
    char *data = nullptr;
    int64_t count = 0;

    String();
    String(const char *str);
    explicit String(const char *str, int64_t count);

    bool operator== (const String &str) const;

    char &operator[] (int64_t index);
    const char &operator[] (int64_t index) const;

    char *ToCStr() const;
    String Join(const String &other);
    bool StartsWith(const String &other) const;
    bool EndsWith(const String &other) const;
    String TrimLeft(int64_t count) const;
    String TrimRight(int64_t count) const;
};

#define FStr(str) static_cast<int>((str).count), (str).data

template<typename T>
struct Array {
    T *data = nullptr;
    int64_t count = 0;
    int64_t capacity = 0;

    T &operator[] (int64_t index) {
        Assert(index >= 0 && index < count);
        return data[index];
    }

    const T &operator[] (int64_t index) const {
        Assert(index >= 0 && index < count);
        return data[index];
    }

    void Free() {
        free(data);
        count = 0;
        capacity = 0;
    }

    void Clear() {
        count = 0;
        capacity = 0;
    }

    void Reserve(int64_t new_capacity) {
        if (new_capacity <= capacity) {
            return;
        }

        data = reinterpret_cast<T *>(realloc(data, sizeof(T) * new_capacity));
        capacity = new_capacity;
    }

    T *Push() {
        if (count == capacity) {
            Reserve(capacity <= 0 ? 8 : capacity * 2);
        }

        T *ptr = &data[count];
        *ptr = T();

        count += 1;

        return ptr;
    }

    T *Push(const T elem) {
        if (count == capacity) {
            Reserve(capacity <= 0 ? 8 : capacity * 2);
        }

        T *ptr = &data[count];
        *ptr = elem;

        count += 1;

        return ptr;
    }

    T Pop() {
        Assert(count > 0);

        T elem = data[count - 1];
        count -= 1;

        return elem;
    }

    T *OrderedInsert(int64_t index) {
        Assert(index >= 0 && index <= count);

        if (count == capacity) {
            Reserve(capacity <= 0 ? 8 : capacity * 2);
        }

        for (int64_t i = count; i > index; i -= 1) {
            data[i] = data[i - 1];
        }

        count += 1;

        auto ptr = &data[index];
        *ptr = T();

        return ptr;
    }

    T *OrderedInsert(int64_t index, T elem) {
        Assert(index >= 0 && index <= count);

        if (count == capacity) {
            Reserve(capacity <= 0 ? 8 : capacity * 2);
        }

        for (int64_t i = count; i > index; i -= 1) {
            data[i] = data[i - 1];
        }

        count += 1;

        auto ptr = &data[index];
        *ptr = elem;

        return ptr;
    }

    T OrderedRemove(int64_t index) {
        Assert(index >= 0 && index < count);

        T elem = data[index];

        count -= 1;

        for (int64_t i = index; i < count; i += 1) {
            data[i] = data[i + 1];
        }

        return elem;
    }

    bool Contains(T value) const {
        for (int64_t i = 0; i < count; i += 1) {
            if (data[i] == value) {
                return true;
            }
        }

        return false;
    }
};

struct StringBuilder {
    char *data = nullptr;
    int64_t count = 0;
    int64_t capacity = 0;

    void Reserve(int64_t capacity);
    void Erase(int64_t count = 1);
    void AppendByte(char byte);
    void AppendString(const String &str);
    void Append(const char *fmt, ...);
    void AppendIndentation(int indentation);
    void AppendComment(const char *comment, int indentation);
    void AppendPascalCase(const char *str);
    String Build() const;
    char *BuildCStr() const;
};

String ReadEntireFile(const char *filename, int64_t *out_bytes_read);
int64_t WriteEntireFile(const char *filename, const void *buffer, int64_t size);
