package com.nizwar.todolist;

import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

public class Application extends FlutterApplication {
    @Override
    public void onCreate() {
        MultiDex.install(this);
        super.onCreate();
    }
}
