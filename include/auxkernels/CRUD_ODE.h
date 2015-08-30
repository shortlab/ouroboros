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

#ifndef CRUD_ODE_H_
#define CRUD_ODE_H_

#include "AuxScalarKernel.h"

//Forward Declarations
class CRUD_ODE;

template<>
InputParameters validParams<CRUD_ODE>();

/**
 * Explicit solve of ODE:
 *
 * dy/dt = -\lambda y  (using forward Euler)
 */
class CRUD_ODE : public AuxScalarKernel
{
public:
  CRUD_ODE(const InputParameters & parameters);
  virtual ~CRUD_ODE();

protected:
  virtual Real computeValue();

  Real _deposition_fraction;
  Real _erosion_fraction;
  const PostprocessorValue & _tke_times_crud;
  const PostprocessorValue & _boiling_rate;
  const PostprocessorValue & _product_release_rate;
  const PostprocessorValue & _wetted_perimeter;
};

#endif /* CRUD_ODE_H_ */
