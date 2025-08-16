buildTypes {
    release {
        minifyEnabled false         // set to true if you want to shrink/obfuscate
        shrinkResources false       // optional

        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
