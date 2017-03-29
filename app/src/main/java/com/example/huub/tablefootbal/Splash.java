package com.example.huub.tablefootbal;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.TextView;

/**
 * Created by Lars on 8-3-2017.
 */

public class Splash extends AppCompatActivity {

    TextView txtUserName;
    public String userName;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen);
        txtUserName = (TextView) findViewById(R.id.userName);


/*        Thread myThread = new Thread() {
            @Override
            public void run() {
                Intent i = new Intent(getApplicationContext(), TableFootbalController.class);
                try {
                    sleep(2000);
                    startActivity(i);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };
        myThread.start();*/
    }


    public void joinGame(View v) {
        userName = txtUserName.getText().toString();
        Intent i = new Intent(getApplicationContext(), TableFootbalController.class);
        i.putExtra("userName", userName);
        startActivity(i);
    }
}