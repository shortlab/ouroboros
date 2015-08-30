#ifndef OUROBOROSAPP_H
#define OUROBOROSAPP_H

#include "MooseApp.h"

class OuroborosApp;

template<>
InputParameters validParams<OuroborosApp>();

class OuroborosApp : public MooseApp
{
public:
  OuroborosApp(InputParameters parameters);
  virtual ~OuroborosApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* OUROBOROSAPP_H */
