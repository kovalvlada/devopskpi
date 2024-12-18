// HTTP_Server.h
#ifndef HTTP_SERVER_H
#define HTTP_SERVER_H

// Function declarations
int CreateHTTPserver();
void sendGETresponse(int fd, char strFilePath[], char strResponse[]);
void sendPUTresponse(int fd, char strFilePath[], char strBody[], char strResponse[]);
void sendHEADresponse(int fd, char strFilePath[], char strResponse[]);

// Constants
#define PORT 8081

#endif // HTTP_SERVER_H