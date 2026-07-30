#include <Core.hpp>

#include <stdarg.h>

int g_num_errors;

void Error(const char *fmt, ...) {
    va_list va;

    printf("\x1b[1;31mError:\x1b[0m ");

    va_start(va, fmt);
    vprintf(fmt, va);
    va_end(va);

    printf("\n");

    g_num_errors += 1;
}

void ErrorExit(const char *fmt, ...) {
    va_list va;

    printf("\x1b[1;31mError:\x1b[0m ");

    va_start(va, fmt);
    vprintf(fmt, va);
    va_end(va);

    printf("\n");

    exit(1);
}

String::String()
    : data(nullptr), count(0) {}

String::String(const char *str)
    : data(const_cast<char *>(str)), count(data ? strlen(data) : 0) {}

String::String(const char *str, int64_t count)
    : data(const_cast<char *>(str)), count(count) {}

bool String::operator== (const String &str) const {
    if (count != str.count) {
        return false;
    }

    return strncmp(data, str.data, count) == 0;
}

char &String::operator[] (int64_t index) {
    Assert(index >= 0 && index < count);
    return data[index];
}

const char &String::operator[] (int64_t index) const {
    Assert(index >= 0 && index < count);
    return data[index];
}

char *String::ToCStr() const {
    char *cstr = reinterpret_cast<char *>(malloc(count + 1));
    memcpy(cstr, data, count);
    cstr[count] = 0;

    return cstr;
}

String String::Join(const String &other) {
    char *new_data = reinterpret_cast<char *>(malloc(count + other.count));
    memcpy(new_data, data, count);
    memcpy(new_data + count, other.data, other.count);

    return String(new_data, count + other.count);
}

bool String::StartsWith(const String &other) const {
    if (count < other.count) {
        return false;
    }

    return strncmp(data, other.data, other.count) == 0;
}

bool String::EndsWith(const String &other) const {
    if (count < other.count) {
        return false;
    }

    return strncmp(data + count - other.count, other.data, other.count) == 0;
}

String String::TrimLeft(int64_t count) const {
    String result = *this;

    if (count <= 0) {
        return result;
    }

    if (count > result.count) {
        result.data += result.count;
        result.count = 0;
    }

    result.data += count;
    result.count -= count;

    return result;
}

String String::TrimRight(int64_t count) const {
    String result = *this;

    if (count <= 0) {
        return result;
    }

    if (count > result.count) {
        result.count = 0;
    }

    result.count -= count;

    return result;
}

void StringBuilder::Reserve(int64_t new_capacity) {
    if (new_capacity <= capacity) {
        return;
    }

    data = reinterpret_cast<char *>(realloc(data, new_capacity));
    capacity = new_capacity;
}

void StringBuilder::Erase(int64_t count) {
    if (count <= 0) {
        return;
    }

    if (count > this->count) {
        this->count = 0;
        return;
    }

    this->count -= count;
}

void StringBuilder::AppendByte(char byte) {
    if (count >= capacity) {
        Reserve(capacity * 2 + 8);
    }

    data[count] = byte;
    count += 1;
}

void StringBuilder::AppendString(const String &str) {
    for (int64_t i = 0; i < str.count; i += 1) {
        AppendByte(str[i]);
    }
}

void StringBuilder::Append(const char *fmt, ...) {
    va_list va;

    va_start(va, fmt);
    int to_append = vsnprintf(NULL, 0, fmt, va);
    va_end(va);

    if (count + to_append + 1000 >= capacity) {
        int64_t total = count + to_append + 1000;
        if (total > capacity * 2 + 8) {
            Reserve(total);
        } else {
            Reserve(capacity * 2 + 8);
        }
    }

    va_start(va, fmt);
    vsnprintf(data + count, capacity - count, fmt, va);
    va_end(va);

    if (to_append > capacity - count) {
        count = capacity;
    } else {
        count += to_append;
    }
}

void StringBuilder::AppendIndentation(int indentation) {
    for (int i = 0; i < indentation; i += 1) {
        AppendString("    ");
    }
}

void StringBuilder::AppendComment(const char *comment, int indentation) {
    if (!comment) {
        return;
    }

    AppendIndentation(indentation);

    bool newline = false;
    bool line_start = true;
    for (int64_t i = 0; comment[i]; i += 1) {
        if (newline) {
            AppendIndentation(indentation);
            newline = false;
            line_start = true;
        }

        char c = comment[i];
        if (line_start) {
            if (c == '\t' || c == ' ') {
                continue;
            }

            line_start = false;
        }

        AppendByte(c);

        if (c == '\n') {
            newline = true;
        }
    }

    if (!newline) {
        AppendByte('\n');
    }
}

void StringBuilder::AppendPascalCase(const char *str) {
    bool uppercase = true;
    for (int i = 0; str[i]; i += 1) {
        if (!isalpha(str[i]) && !isdigit(str[i]) && str[i] != '_') {
            uppercase = true;
        } else if (uppercase) {
            AppendByte(toupper(str[i]));
            uppercase = false;
        } else {
            AppendByte(str[i]);
        }
    }
}

String StringBuilder::Build() const {
    return String(data, count);
}

char *StringBuilder::BuildCStr() const {
    char *result = reinterpret_cast<char *>(malloc(count + 1));
    memcpy(result, data, count);
    result[count] = 0;

    return result;
}

String ReadEntireFile(const char *filename, int64_t *out_bytes_read) {
    FILE *file = fopen(filename, "rb");
    if (!file) {
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    int64_t size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char *result = reinterpret_cast<char *>(malloc(size + 1));
    if (!result) {
        fclose(file);
        return NULL;
    }

    int64_t bytes_read = fread(result, 1, size, file);
    fclose(file);

    if (bytes_read <= size) {
        result[bytes_read] = 0;
    } else {
        result[size] = 0;
    }

    if (out_bytes_read) {
        *out_bytes_read = bytes_read;
    }

    return String(result, bytes_read);
}

int64_t WriteEntireFile(const char *filename, const void *buffer, int64_t size) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        return 0;
    }

    size_t written = fwrite(buffer, 1, size, file);
    fclose(file);

    return written;
}
