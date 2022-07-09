#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct Player {
    char position[256];
    int isCaptain;
    double pay;
} Player;

typedef struct Node {
    struct Player *thisPlayer;
    struct Node *nextPlayer;
} Node;

void newNode(Node *retNode, Player *temp) {
    char cha;
    int cont = 1;
    int position = 0;
    printf("Enter a position: ");
    while (cont == 1) {
        cha = fgetc(stdin);

        if (cha == EOF || cha == '\n') {
            temp->position[position] = '\0';
            cont = 0;
        } else {
            temp->position[position] = cha;
        }
        position++;
    }
    char captain[] = {'c', 'a', 'p', 't', 'a', 'i', 'n', '\0'};
    position = 0;
    int matches = 1;
    while (position < 7 && matches) {
        if (temp->position[position] != captain[position]) {
            matches = 0;
        }
        position++;
    }
    if (matches && temp->position[position] == '\0') {
        temp->isCaptain = 1;
    } else {
        temp->isCaptain = 0;
    }
    printf("Enter a pay: ");
    scanf("%lf", &temp->pay);
    printf(
        "New Player created with\nPosition: %s\nIsCaptain: %i\nPay:%0.2lf\n",
        temp->position, temp->isCaptain, temp->pay);
    fflush(stdin);
    retNode->thisPlayer = temp;
}

void addNodeToEnd(Node *head, Node *newNode) {
    Node *lastNode = head;
    while (lastNode != NULL && lastNode->nextPlayer != NULL) {
        lastNode = lastNode->nextPlayer;
    }
    if (lastNode != NULL) {
        lastNode->nextPlayer = newNode;
    } else {
        lastNode = newNode;
    }
}

int main(int argc, char const *argv[]) {
    Node *head = NULL;
    int numNodes;
    printf("How many nodes to insert?\n");
    scanf("%i", &numNodes);
    fflush(stdin);
    for (int i = 0; i < numNodes; i++) {
        Node next;
        Player temp;
        newNode(&next, &temp);
        addNodeToEnd(head, &next);
    }
    return 0;
}
