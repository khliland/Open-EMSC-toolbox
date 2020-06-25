function [ZEMSCMod]=emscmod_to_saisir(EMSCMod);
%emscmod_to_saisir
%[ZEMSCMod]=emscmod_to_saisir(EMSCMod);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  01.05.08                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description: Converts EMSC model spectra to saisir structure                        %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ZEMSCMod.d=EMSCMod.Model';
ZEMSCMod.i=EMSCMod.ModelSpecNames;
ZEMSCMod.v=EMSCMod.ModelVariables;



