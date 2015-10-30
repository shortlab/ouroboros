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

#include "PhaseConcentrationGradient.h"

#include <algorithm>
#include <limits>

template<>
InputParameters validParams<PhaseConcentrationGradient>()
{
  // Define the parameters
  InputParameters params = validParams<ElementVariablePostprocessor>();

  params.addRequiredCoupledVar("phase_of_interest", "The variable name of the phase in which we want a concentration gradient");

  return params;
}

PhaseConcentrationGradient::PhaseConcentrationGradient(const InputParameters & parameters) :
  ElementVariablePostprocessor(parameters),
  _phase_of_interest(coupledValue("phase_of_interest"))
{}

void
PhaseConcentrationGradient::initialize()
{
  _value = -std::numeric_limits<Real>::max();
}

void
PhaseConcentrationGradient::computeQpValue()
{
}

Real
PhaseConcentrationGradient::getValue()
{
  return _value;
}

void
PhaseConcentrationGradient::execute()
{
  unsigned int counter = 0;
  for (_qp=0; _qp<_qrule->n_points(); _qp++)
    if (MooseUtils::absoluteFuzzyEqual(_phase_of_interest[_qp], 1.0)) // If we're fully in the phase of interest
    {
      counter++;
    }
  if (counter == _qrule->n_points())
  {
    if (-_grad_u[0](0) > _value)
      _value = -_grad_u[0](0);
  }
}

void
PhaseConcentrationGradient::threadJoin(const UserObject & y)
{
  const PhaseConcentrationGradient & pps = static_cast<const PhaseConcentrationGradient &>(y);
  _value = std::max(_value, pps._value);
}

void
PhaseConcentrationGradient::finalize()
{
  gatherMax(_value);
}
