// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.embedding.engine.systemchannels;

import android.os.Build;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.FlutterInjector;
import io.flutter.Log;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.dynamicfeatures.DynamicFeatureManager;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.json.JSONException;
import org.json.JSONObject;

public class SplitAotChannel {
  private static final String TAG = "SplitAotChannel";

  @NonNull public final MethodChannel channel;
  @Nullable DynamicFeatureManager dynamicFeatureManager;


  private final MethodChannel.MethodCallHandler parsingMethodHandler =
      new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
          if (dynamicFeatureManager == null) {
            // If no DynamicFeatureManager has been injected, then this channel is a no-op.
            return;
          }
          String method = call.method;
          Object args = call.arguments;
          Log.v(TAG, "Received '" + method + "' message.");
          switch (method) {
            case "SplitAot.installDynamicFeature":
              try {
                final JSONObject arguments = (JSONObject) args;
                final int loadingUnitId = arguments.getInt("loadingUnitId");
                final String moduleName = arguments.getString("moduleName");
                dynamicFeatureManager.installDynamicFeature(loadingUnitId, moduleName);
              } catch (JSONException exception) {
                result.error("error", exception.getMessage(), null);
              }
              result.success(null);
              break;
            case "SplitAot.getDynamicFeatureInstallState":
              try {
                final JSONObject arguments = (JSONObject) args;
                final int loadingUnitId = arguments.getInt("loadingUnitId");
                final String moduleName = arguments.getString("moduleName");
                dynamicFeatureManager.getDynamicFeatureInstallState(loadingUnitId, moduleName);
              } catch (JSONException exception) {
                result.error("error", exception.getMessage(), null);
              }
              result.success(null);
              break;
            case "SplitAot.loadAssets":
              try {
                final JSONObject arguments = (JSONObject) args;
                final int loadingUnitId = arguments.getInt("loadingUnitId");
                final String moduleName = arguments.getString("moduleName");
                dynamicFeatureManager.loadAssets(loadingUnitId, moduleName);
              } catch (JSONException exception) {
                result.error("error", exception.getMessage(), null);
              }
              result.success(null);
              break;
            case "SplitAot.loadDartLibrary":
              try {
                final JSONObject arguments = (JSONObject) args;
                final int loadingUnitId = arguments.getInt("loadingUnitId");
                final String moduleName = arguments.getString("moduleName");
                dynamicFeatureManager.loadAssets(loadingUnitId, moduleName);
              } catch (JSONException exception) {
                result.error("error", exception.getMessage(), null);
              }
              result.success(null);
              break;
            default:
              result.notImplemented();
              break;
          }
        }
      };

  /**
   * Constructs a {@code SplitAotChannel} that connects Android to the Dart code running in {@code
   * dartExecutor}.
   *
   * <p>The given {@code dartExecutor} is permitted to be idle or executing code.
   *
   * <p>See {@link DartExecutor}.
   */
  public SplitAotChannel(@NonNull DartExecutor dartExecutor) {
    this.channel =
        new MethodChannel(dartExecutor, "flutter/splitaot", JSONMethodCodec.INSTANCE);
    channel.setMethodCallHandler(parsingMethodHandler);
    dynamicFeatureManager = FlutterInjector.instance().dynamicFeatureManager();
  }
}