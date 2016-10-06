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

#ifndef OXIDETHICKNESSMAI_H
#define OXIDETHICKNESSMAI_H

#include "AuxKernel.h"

//Forward Declarations
class OxideThicknessMAI;

/**
 * validParams returns the parameters that this AuxKernel accepts / needs
 * The actual body of the function MUST be in the .C file.
 */
template<>
InputParameters validParams<OxideThicknessMAI>();

class OxideThicknessMAI : public AuxKernel
{
public:

  OxideThicknessMAI(const InputParameters & parameters);

protected:
  virtual Real computeValue();

  /**
   * This MooseArray will hold the reference we need to our
   * material property from the Material class
   */

  const VariableValue & _T;
  Real _BLiRatio;
  Real _pH;
  Real _H2;
  Real _ECP;
};
#endif //OXIDETHICKNESSMAI_H
