#ifndef REQUEST_H_
#define REQUEST_H_
#include <string>
class Request {
public:
  Request();
  virtual ~Request();

  static void init();
  static void done();
};

#endif /* REQUEST_H_ */
