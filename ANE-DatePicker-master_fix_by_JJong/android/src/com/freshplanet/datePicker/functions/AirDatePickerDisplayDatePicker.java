//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.datePicker.functions;

import android.annotation.TargetApi;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.datePicker.ExtensionContext;

@TargetApi(14)
public class AirDatePickerDisplayDatePicker implements FREFunction
{
	private static final String TAG = "[AirDatePicker] - AirDatePickerDisplayDatePicker";
	
	public FREObject call(FREContext context, FREObject[] args)
	{
		Log.d(TAG, "Entering call");
		
		String year = null;
		String month = null;
		String day = null;
		try
		{
			year = args[0].getAsString();
			month = args[1].getAsString();
			day = args[2].getAsString();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
		
		((ExtensionContext) context).displayDatePicker( Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day) );
		
		Log.d(TAG, "Exiting call");
		
		return null;
	}
}