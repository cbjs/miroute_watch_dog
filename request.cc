#include "request.h"

#include "curl/curl.h"

using namespace std;

Request::Request() {
}

Request::~Request() {
}

void Request::init() {
  // exactly only once
  curl_global_init(CURL_GLOBAL_ALL);
}

void Request::done() {
  // exactly only once
  curl_global_cleanup();
}
