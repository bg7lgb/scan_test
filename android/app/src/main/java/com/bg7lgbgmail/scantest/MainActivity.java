package com.bg7lgbgmail.scantest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;


import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String STREAM_CHANNEL_NAME = "bg7lgb/scan_event";
  private static final String BROADCAST_NAME = "com.scanner.broadcast";  // C6000r的广播名
  private static final String BROADCAST_NAME_D8 = "ACTION_BAR_SCAN";   // 中光远防爆机扫码广播名

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new EventChannel(getFlutterView(), STREAM_CHANNEL_NAME).setStreamHandler(
            new EventChannel.StreamHandler() {
              BroadcastReceiver scanReceiver;

              @Override
              public void onListen(Object o, EventChannel.EventSink eventSink) {
                scanReceiver = createScanReceiver(eventSink);

                IntentFilter intentFilter = new IntentFilter();
                intentFilter.addAction(BROADCAST_NAME);
                intentFilter.addAction(BROADCAST_NAME_D8);
                registerReceiver(scanReceiver, intentFilter);
              }

              @Override
              public void onCancel(Object o) {
                unregisterReceiver(scanReceiver);
                scanReceiver = null;
              }
            }
    );
  }

  private BroadcastReceiver createScanReceiver(final EventChannel.EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {

        String data;
        // Log.d("abc", "receive");
        if (intent.getAction().equals(BROADCAST_NAME)) {
            data = intent.getStringExtra("data");
//            Log.d("data", data);
        } else {
            data = intent.getStringExtra("EXTRA_SCAN_DATA");
//            Log.d("EXTRA_SCAN_DATA", data);
        }
        events.success(data);
      }
    };
  }
}
