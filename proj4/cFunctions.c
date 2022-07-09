/*
Name: Reagan Armstrong
user_id: GX74574
Description: Project 4 of CMSC 313. This is the c file with all of the
             subroutines made in c. These incluse the subroutine to display all
             of string strings in a string array, read in a new string and put
             it in the array, and the frequency analysis decryption algorithm.
*/

#include <stdio.h>
#include <stdlib.h>

// displats the strings in arr
void display(char* arr[]) {
    for (int i = 0; i < 10; i++) {
        printf("Message[%d]: %s\n", i, arr[i]);
    }
}

// reads in a new message and places it at arr[curr-1]
// returns 1 if valid input , 0 if invalid
int read(char* arr[], int numOriginal, int curr) {
    printf("Enter new message: ");
    int buffer = 256;
    int position = 0;
    int valid_string;
    // creates a dynamic char arr
    char* cmd = malloc(sizeof(char) * buffer);
    int cha;
    int cont = 1;
    // handles if they just enter immedietly
    int incrementedOnce = 0;
    // while they have not entered, excluding the first pass
    while (cont == 1) {
        cha = fgetc(stdin);
        if (cha == EOF || cha == '\n') {
            if (incrementedOnce > 0 &&
                (cmd[position - 1] == '.' || cmd[position - 1] == '!' ||
                 cmd[position - 1] == '?')) {
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
        // resizes cmd if it is full
        if (position >= buffer) {
            buffer += 256;
            cmd = realloc(cmd, buffer);
        }
        // to make sure that it doesn't give an error if they immedietly press
        // enter
        if (incrementedOnce == 0) {
            incrementedOnce = 1;
        }
    }
    // if its a valid string replace the string in arr
    if (valid_string == 1) {
        // this is to make sure I don't free a non freeable string
        if (numOriginal > 0) {
            arr[curr - 1] = cmd;
        } else {
            free(arr[curr - 1]);
            arr[curr - 1] = cmd;
        }
        return 1;
        // if their message is invalid
    } else {
        printf("invalid message, keeping current.\n");
        free(cmd);
        return 0;
    }
}

// checks if all of the intehers in arr are zero
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

// prints the decrypted string with the mostFrequent and its offset from the
// picot
void printDecryption(char* str, char mostFreq, char pivot) {
    int size = sizeOfStr(str);
    // copys the string so we don't change original string
    char strCopy[size];
    int offset;
    // calculates the offset based on wether the mostFreq is capital or
    // lowercase
    if (mostFreq >= 65 && mostFreq <= 90) {
        offset = (mostFreq - 65) - (pivot - 97);

    } else {
        offset = (mostFreq - 97) - (pivot - 97);
    }
    // further calculation of the offset
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
    // applies offset and preserves case for all of the character in strCopy
    for (int i = 0; i < size; i++) {
        if (strCopy[i] >= 65 && strCopy[i] <= 90) {
            strCopy[i] = ((strCopy[i] - 65) + offset) % 26 + 65;
        } else if (strCopy[i] >= 97 && strCopy[i] <= 122) {
            strCopy[i] = ((strCopy[i] - 97) + offset) % 26 + 97;
        }
    }
    // prints out the new string
    printf("%s\n", strCopy);
}

// get the index with the largest value in arr
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

// decrypt str with frequency analysis
void decrypt(char* str) {
    int index = 0;
    int buffer = 0;
    char* letters;
    int* frequencies;
    // if the string isn't empty
    if (str[0] != '\0') {
        int letterFound;
        char temp;
        // find the frequencies of all the characters in str
        for (int i = 0; str[i] != '\0'; i++) {
            letterFound = 0;
            // checks if the letter has already been found, if so inc frequenct
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
            // if letter has not been found before increase the sizes of
            // frequencies and letters arrays and update accordingly
            if (letterFound == 0) {
                if (buffer >= 1) {
                    buffer += 1;
                    letters = realloc(letters, sizeof(char) * buffer);
                    frequencies = realloc(frequencies, sizeof(int) * buffer);
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
        // given frequencies, preforms decryptions
        int maxIndex = 0;
        char pivots[] = {'e', 't', 'a', 'o', 'i'};
        for (int i = 0; i < 5; i++) {
            // if we have not looked at all of the letters already
            if (allZero(frequencies, buffer) == 0) {
                // find the most frequent letter
                maxIndex = getMaxIndex(frequencies, buffer);
                char mostCommonLetter = letters[maxIndex];
                // zero out the frequency
                frequencies[maxIndex] = 0;
                // print the decryption with the pivot;
                printDecryption(str, letters[maxIndex], pivots[i]);
                maxIndex = 0;
                // if we have already looked at all of the letters, loop
                // thorugh them in order
            } else {
                maxIndex %= buffer;
                printDecryption(str, letters[maxIndex], pivots[i]);
                maxIndex += 1;
            }
            if (i < 4) {
                printf("OR\n");
            }
        }
        // handles if the string is empty
    } else {
        printf("This string is empty! It has no decryption.\n");
    }
    // free the letters and frequencies arrays
    free(letters);
    free(frequencies);
}