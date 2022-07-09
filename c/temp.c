"""
Name: Reagan Armstrong
user_id: GX74574
Description: project 4 of CMSC 313 which encompases
             a ceasar cipher, a string array that must be displayable and manipulatable,
             and a frequency analysis decryption algroithm.
"""
#include <stdio.h>
#include <stdlib.h>

int display(char* arr[]) {
    for (int i = 0; i < 10; i++) {
        printf("Message[%d]: %s\n", i, arr[i]);
    }
    return 0;
}

int read(char* arr[], int numOriginal, int curr) {
    printf("numOriginal = %i\n", numOriginal);
    printf("curr = %i\n", curr);
    printf("Enter new message: ");
    int buffer = 256;
    int position = 0;
    int valid_string;
    char* cmd = malloc(sizeof(char) * buffer);

    int cha;
    int cont = 1;

    while (cont == 1) {
        cha = fgetc(stdin);
        if (cha == EOF || cha == '\n') {
            if (cmd[position - 1] == '.' || cmd[position - 1] == '!' ||
                cmd[position - 1] == '?') {
                valid_string = 1;
            } else {
                valid_string = 0;
            }
            cmd[position] = '\0';
            cont = 0;
        } else {
            cmd[position] = cha;
        }
        position++;
        if (position >= buffer) {
            buffer += 256;
            cmd = realloc(cmd, buffer);
        }
    }
    if (valid_string == 1) {
        if (numOriginal > 0) {
            arr[curr - 1] = cmd;
        } else {
            free(arr[curr - 1]);
            arr[curr - 1] = cmd;
        }
        return 1;
    } else {
        free(cmd);
        return 0;
    }
}
int allZero(int* arr, int size) {
    for (int i = 0; i < size; i++) {
        if (arr[i] != 0) {
            return 0;
        }
    }
    return 1;
}
// returns size with null char
int sizeOfStr(char* str) {
    int counter = 0;
    while (str[counter] != '\0') {
        counter++;
    }
    return counter + 1;
}
void printDecryption(char* str, char mostFreq, char pivot) {
    int size = sizeOfStr(str);
    char strCopy[size];
    int offset;
    if (mostFreq >= 65 && mostFreq <= 90) {
        offset = (mostFreq - 65) - (pivot - 97);

    } else {
        offset = (mostFreq - 97) - (pivot - 97);
    }
    if (offset < 0) {
        offset -= 26;
        offset = abs(offset);
    } else {
        offset = 26 - offset;
    }
    // copies arr
    for (int i = 0; i < size; i++) {
        strCopy[i] = str[i];
    }
    for (int i = 0; i < size; i++) {
        if (strCopy[i] >= 65 && strCopy[i] <= 90) {
            strCopy[i] = ((strCopy[i] - 65) + offset) % 26 + 65;
        } else if (strCopy[i] >= 97 && strCopy[i] <= 122) {
            strCopy[i] = ((strCopy[i] - 97) + offset) % 26 + 97;
        }
    }
    printf("%s\n", strCopy);
}

int getMaxIndex(int* arr, int size) {
    int max = 0;
    if (size < 1) {
        return 0;
    }
    for (int i = 0; i < size; i++) {
        if (arr[i] > arr[max]) {
            max = i;
        }
    }
    return max;
}
void decrypt(char* str) {
    int index = 0;
    int buffer = 0;
    char* letters;
    int* frequencies;
    if (str[0] != '\0') {
        int letterFound;
        char temp;
        for (int i = 0; str[i] != '\0'; i++) {
            letterFound = 0;
            if (((str[i] >= 65 && str[i] <= 90) ||
                 (str[i] >= 97 && str[i] <= 122))) {
                temp = str[i];
                if (temp < 97) {
                    temp += 97 - 65;
                }
                for (int j = 0; j < buffer && letterFound == 0; j++) {
                    if (letters[j] == temp) {
                        frequencies[j]++;
                        letterFound = 1;
                    }
                }
            } else {
                letterFound = 1;
            }
            if (letterFound == 0) {
                if (buffer >= 1) {
                    buffer += 1;
                    letters = realloc(letters, buffer);
                    frequencies = realloc(frequencies, buffer);
                    letters[buffer - 1] = temp;
                    frequencies[buffer - 1] = 1;
                } else {
                    buffer += 1;
                    letters = malloc(sizeof(char) * buffer);
                    frequencies = malloc(sizeof(int) * buffer);
                    letters[buffer - 1] = temp;
                    frequencies[buffer - 1] = 1;
                }
            }
        }
        int maxIndex = 0;
        char pivots[] = {'e', 't', 'a', 'o', 'i'};
        for (int i = 0; i < 5; i++) {
            if (allZero(frequencies, buffer) == 0) {
                maxIndex = getMaxIndex(frequencies, buffer);
                char mostCommonLetter = letters[maxIndex];
                frequencies[maxIndex] = 0;
                printDecryption(str, letters[maxIndex], pivots[i]);
                maxIndex = 0;
            } else {
                maxIndex %= buffer;
                printDecryption(str, letters[maxIndex], pivots[i]);
                maxIndex += 1;
            }
            if (i < 4) {
                printf("OR\n");
            }
        }
    } else {
        printf("This string is empty! It has no decryption.\n");
    }
    free(letters);
    free(frequencies);
}

int main(int argc, char const* argv[]) {
    char arr[] = "ZzZoo";
    decrypt(arr);
    char b = 'Z';
    char off = 'e';
    int temp;
    int b_pos = (b >= 97 && b <= 122);
    printf("%i\n", b_pos);
    temp = (b - 97) - (off - 97);
    if (temp < 0) {
        temp -= 26;
        temp = abs(temp);
    } else {
        temp = 26 - temp;
    }
    b = ((b - 97) + temp) % 26 + 97;
    printf("%i\n", temp);
    // printf("%c\n", b);

    return 0;
}
