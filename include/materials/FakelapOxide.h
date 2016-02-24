/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef FAKELAPOXIDE_H
#define FAKELAPOXIDE_H

#include "Material.h"

//Forward Declarations
class FakelapOxide;

template<>
InputParameters validParams<FakelapOxide>();

class FakelapOxide : public Material
{
public:
  FakelapOxide(const InputParameters & parameters);

protected:
//  virtual void initQpStatefulProperties();
  virtual void computeQpProperties();

private:

  /**
   * These variables will hold key values from the
   * input file for material property calculation.
   */

  // Coupled variables used in calculation (TBD)
  const VariableValue & _T;
  const VariableValue & _D_0_Ni;
  const VariableValue & _E_A_Ni;
  const VariableValue & _D_0_Fe;
  const VariableValue & _E_A_Fe;

  /**
   * This is the member reference that will hold the
   * computed values from this material class.
   */

  // Diffusivities of radiation defects
  MaterialProperty<Real> & _Ni_diffusivity_matprop;
  MaterialProperty<Real> & _Fe_diffusivity_matprop;
  MaterialProperty<Real> & _rho_h2o;
};

#endif //FAKELAPOXIDE_H
