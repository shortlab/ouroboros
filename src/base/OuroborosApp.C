#include "OuroborosApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"

#include "ReactorHeatSource.h"
#include "CRUD_ODE.h"

template<>
InputParameters validParams<OuroborosApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

OuroborosApp::OuroborosApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  OuroborosApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  OuroborosApp::associateSyntax(_syntax, _action_factory);
}

OuroborosApp::~OuroborosApp()
{
}

// External entry point for dynamic application loading
extern "C" void OuroborosApp__registerApps() { OuroborosApp::registerApps(); }
void
OuroborosApp::registerApps()
{
  registerApp(OuroborosApp);
}

// External entry point for dynamic object registration
extern "C" void OuroborosApp__registerObjects(Factory & factory) { OuroborosApp::registerObjects(factory); }
void
OuroborosApp::registerObjects(Factory & factory)
{
  registerKernel(ReactorHeatSource);
  registerScalarKernel(CRUD_ODE);
}

// External entry point for dynamic syntax association
extern "C" void OuroborosApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { OuroborosApp::associateSyntax(syntax, action_factory); }
void
OuroborosApp::associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
}
