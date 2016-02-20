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

#ifndef SOLUBLE_ODE_H
#define SOLUBLE_ODE_H

#include "AuxScalarKernel.h"

//Forward Declarations
class Soluble_ODE;

template<>
InputParameters validParams<Soluble_ODE>();

/**
 * Explicit solve of ODE:
 *
 * dy/dt = -\lambda y  (using forward Euler)
 */
class Soluble_ODE : public AuxScalarKernel
{
public:
  Soluble_ODE(const InputParameters & parameters);
  virtual ~Soluble_ODE();

protected:
  virtual Real computeValue();

  const PostprocessorValue & _product_release_rate;
  const PostprocessorValue & _wetted_perimeter;
};

#endif /* SOLUBLE_ODE_H */
