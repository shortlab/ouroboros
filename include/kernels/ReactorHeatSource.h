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

#ifndef REACTORHEATSOURCE_H
#define REACTORHEATSOURCE_H

#include "Kernel.h"

class ReactorHeatSource;

template<>
InputParameters validParams<ReactorHeatSource>();

class ReactorHeatSource : public Kernel
{
public:

  ReactorHeatSource(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();

private:

  const VariableValue & _wetted_perimeter;
  const VariableValue & _wall_temp;
};

#endif //REACTORHEATSOURCE_H
