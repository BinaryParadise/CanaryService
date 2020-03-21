package com.frontend.utils;

import com.notnoop.apns.APNS;
import com.notnoop.apns.ApnsService;
import com.notnoop.apns.ApnsServiceBuilder;
import com.notnoop.apns.EnhancedApnsNotification;
import com.notnoop.apns.internal.Utilities;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;

public class MCAPNSService {

    public static void appleAPNSV2(String token, boolean inhouse, boolean production) throws UnsupportedEncodingException {
        String path = "src/main/resources/Cert_" + (inhouse ? "Inhouse" : "") + "_" + (production ? "Production" : "Development") + "_aps.p12";
        System.out.println("证书：" + path);
        ApnsServiceBuilder serviceBuilder = APNS.newService();
        serviceBuilder.withCert(path, "111111");
        if (production) {
            serviceBuilder = serviceBuilder.withProductionDestination();
        } else {
            serviceBuilder = serviceBuilder.withSandboxDestination();
        }
        ApnsService service = serviceBuilder.build();

        String payload = APNS.newPayload()
                .badge(1)
                .sound("default")
                .alertBody("what do you think?").toString();

        int now = (int) (new Date().getTime() / 1000);

        EnhancedApnsNotification notification = new EnhancedApnsNotification(EnhancedApnsNotification.INCREMENT_ID() /* Next ID */,
                now + 60 * 60 /* Expire in one hour */,
                token /* Device Token */,
                payload);
        System.out.println(Utilities.encodeHex(notification.getDeviceToken()));
        service.push(notification);

        service.getInactiveDevices().forEach((k, v) -> System.out.println("失效Token:"+k));
    }

    public static void main(String[] args) throws IOException {
        System.out.println(new File("").getAbsolutePath());
        //普通包
        //appleAPNSV2("7c804751714fb503e55e3d6fff0df966b2a5f743c47de9ccbb1f55cc7f368346", false, false);
        //企业包
        appleAPNSV2("57592ccc5359600e0740211acccadb29dabfc55f2ce2e61428f18d81078afd7e", true, false);
        //appleAPNS("eba6fe997c5e8aab622cf6f4a0914750b32e0f47d569944a43c2676ba949b636",true,true);
        //System.in.read();
    }

}
