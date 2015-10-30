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

#ifndef PHASECONCENTRATIONGRADIENT_H
#define PHASECONCENTRATIONGRADIENT_H

#include "ElementVariablePostprocessor.h"

//Forward Declarations
class PhaseConcentrationGradient;

// Input parameters
template<>
InputParameters validParams<PhaseConcentrationGradient>();

/// A postprocessor for collecting the nodal min or max value
class PhaseConcentrationGradient : public ElementVariablePostprocessor
{
public:

  /**
   * Class constructor
   * @param name The name of the postprocessor
   * @param parameters The input parameters
   */
  PhaseConcentrationGradient(const InputParameters & parameters);
  virtual void initialize();
  virtual Real getValue();
  virtual void threadJoin(const UserObject & y);
  virtual void execute();
  virtual void finalize();

protected:
  /// Get the extreme value at each quadrature point
  virtual void computeQpValue();

  /// Get the phase in which we want the concentration gradient
  VariableValue & _phase_of_interest;
  Real _value;

  /// Get the actual variable whose concentration we want

};

#endif
