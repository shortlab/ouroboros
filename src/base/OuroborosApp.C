#include "OuroborosApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
// #include "ModulesApp.h"
#include "PhaseFieldApp.h"
#include "MiscApp.h"

#include "ReactorHeatSource.h"
#include "OxideThickness.h"
#include "OxideThicknessMAI.h"
#include "MetalRelease.h"
#include "Convection.h"
#include "MatPropDiffusion.h"
#include "FakelapOxide.h"
#include "CRUD_ODE.h"
#include "Soluble_ODE.h"
#include "PhaseConcentrationGradient.h"

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
//  ModulesApp::registerObjects(_factory);
  PhaseFieldApp::registerObjects(_factory);
  MiscApp::registerObjects(_factory);
  OuroborosApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
//  ModulesApp::associateSyntax(_syntax, _action_factory);
  PhaseFieldApp::associateSyntax(_syntax, _action_factory);
  MiscApp::associateSyntax(_syntax, _action_factory);
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
  registerKernel(MatPropDiffusion);
  registerKernel(Convection);
  registerAuxKernel(OxideThickness);
  registerAuxKernel(OxideThicknessMAI);
  registerAuxKernel(MetalRelease);
  registerScalarKernel(CRUD_ODE);
  registerScalarKernel(Soluble_ODE);
  registerPostprocessor(PhaseConcentrationGradient);

  // Register materials classes
  registerMaterial(FakelapOxide);

}

// External entry point for dynamic syntax association
extern "C" void OuroborosApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { OuroborosApp::associateSyntax(syntax, action_factory); }
void
OuroborosApp::associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
}
