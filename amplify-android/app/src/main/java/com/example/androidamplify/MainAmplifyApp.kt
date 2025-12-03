package com.example.androidamplify

import android.app.Application
import android.util.Log
import com.amplifyframework.AmplifyException
import com.amplifyframework.core.Amplify
import com.amplifyframework.core.configuration.AmplifyOutputs

class MainAmplifyApp: Application() {
    override fun onCreate() {
        super.onCreate()

        try {
            // Add plugins like
            // Amplify.addPlugin(...)
            // here
            Amplify.configure(AmplifyOutputs(R.raw.amplify_outputs), applicationContext)
            Log.i("AndroidAmplify", "Initialized Amplify")
        } catch (error: AmplifyException) {
            Log.e("AndroidAmplify", "Could not initialize Amplify", error)
        }
    }
}
