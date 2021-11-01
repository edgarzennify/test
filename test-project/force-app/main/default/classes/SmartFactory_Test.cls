/*
   Copyright 2011 Mavens Consulting, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.s
   See the License for the specific language governing permissions and
   limitations under the License.
*/   

@isTest
private class SmartFactory_Test {
    static {
        SmartFactory.FillAllFields = true; // increase test coverage without creating custom objects
    }

    private static testMethod void code_coverage() {
      Grenzsoldat__c gd = (Grenzsoldat__c)SmartFactory.createSObject('Grenzsoldat__c');
      gd.Bogus__c = 'test';
      insert gd;
    }  

}