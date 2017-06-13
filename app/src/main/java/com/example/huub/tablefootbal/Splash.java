package com.example.huub.tablefootbal;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.WindowManager;
import android.widget.Toast;

import io.socket.client.Socket;

/**
 * Created by Lars on 8-3-2017.
 */

public class Splash extends AppCompatActivity implements SocketConnection.onSocketGotLoginEvent, SocketConnection.onErrorSocketEvent, SocketConnection.onPlayGameEvent {

    private String prefsFile = Constants.PREFERENCEFILENAME;
    private Socket mSocket;
    private boolean mUsername;
    private boolean mAppleTV;
    private boolean errorOccured;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen);


        //Set socketconnection
        SocketConnection app = (SocketConnection) getApplication();
        mSocket = app.getSocket(this);
        mSocket.connect();

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);;

        SharedPreferences sharedPrefs = getSharedPreferences(prefsFile, MODE_PRIVATE);
        SharedPreferences.Editor ed;
        if(!sharedPrefs.contains("initialized")) {
            ed = sharedPrefs.edit();
            //Indicate that the default shared prefs have been set
            ed.putBoolean("initialized", true);
            ed.commit();
            System.out.println("is not initialized");

            System.out.println("username does not exists");
            Intent i = new Intent(this, joinScreen.class);
            startActivity(i);
            finish();

        } else{
            System.out.println("is initialized");
            mUsername = sharedPrefs.contains("username");
            mAppleTV = sharedPrefs.contains("joinCode");
            if (mAppleTV){
                Constants.JOINCODE = sharedPrefs.getString("joinCode","");
            }
            if (mUsername){
                System.out.println("username exists");
                String username = sharedPrefs.getString("username", "");
                Constants.USERNAME = username;
                mSocket.emit("registeredUserConnect", username, Constants.DEVICE);
            }else {
                System.out.println("username does not exists");
                Intent i = new Intent(this, joinScreen.class);
                startActivity(i);
                finish();
            }
        }
    }

    @Override
    public void loginSucceeded(boolean loginSucceeded) {
        if (loginSucceeded){
            Constants.isLogedin = true;
            if(mAppleTV){
                mSocket.emit("userJoinAppleTV", Constants.JOINCODE);
            } else{
                Intent i = new Intent(this, mainMenu.class);
                startActivity(i);
                finish();
            }
        } else{
            Toast.makeText(this, "login failed", Toast.LENGTH_LONG).show();
            Intent i = new Intent(this, joinScreen.class);
            startActivity(i);
            finish();
        }
    }

    @Override
    public void startLocal() {
        Intent i = new Intent(this, localGameSettings.class);
        startActivity(i);
        finish();
    }

    @Override
    public void usernameExists(boolean usernameExists) {

    }

    @Override
    public void connectedToAppleTV(boolean connectedToAppleTV, boolean goToChooseTeam) {
        System.out.println("connectedToAppleTV?: " + connectedToAppleTV);
        if (connectedToAppleTV){
            if (Constants.isPlayerOne){
                Intent i = new Intent(this, mainMenu.class);
                startActivity(i);
                finish();
            } else{
                if (goToChooseTeam){
                    Intent i = new Intent(this, localGameSettings.class);
                    startActivity(i);
                    finish();
                } else{
                    Intent i = new Intent(this, waiting_screen.class);
                    startActivity(i);
                    finish();
                }
            }
        } else{
            Intent i = new Intent(this, mainMenu.class);
            startActivity(i);
            finish();
        }
    }

    @Override
    public void isPlayerOne(boolean isPlayerOne) {

    }

    @Override
    public void onDisconnectAppleTV() {

    }

    @Override
    public void disconnected() {
        Toast.makeText(this, "The server is down", Toast.LENGTH_LONG).show();
    }

    @Override
    public void socketError(String error) {
        Toast.makeText(this, "socket error: " + error, Toast.LENGTH_LONG).show();
        Constants.isConnectedServer = false;
        Intent i = new Intent(this, ErrorScreen.class);
        startActivity(i);

    }

    @Override
    public void socketConnectError(String error) {
        Toast.makeText(this, "socket error: " + error, Toast.LENGTH_LONG).show();
        Constants.isConnectedServer = false;
        Intent i = new Intent(this, ErrorScreen.class);
        startActivity(i);
    }

    @Override
    public void enableStart() {

    }

    @Override
    public void chooseSide() {

    }

    @Override
    public void startGame() {

    }
}