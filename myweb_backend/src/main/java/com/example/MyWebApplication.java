package com.example;

import com.example.entity.SiteProfile;
import com.example.repository.SiteProfileRepository;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@RestController
public class MyWebApplication {

    private final SiteProfileRepository siteProfileRepository;

    public MyWebApplication(SiteProfileRepository siteProfileRepository) {
        this.siteProfileRepository = siteProfileRepository;
    }

    public static void main(String[] args) {
        SpringApplication.run(MyWebApplication.class, args);
    }

    @GetMapping("/api/info")
    public ResponseEntity<Map<String, Object>> getInfo() {
        return siteProfileRepository.findFirstByOrderByIdAsc()
                .map(profile -> {
                    Map<String, Object> data = new HashMap<>();
                    data.put("name", profile.getName());
                    data.put("title", profile.getTitle());
                    data.put("subtitle", profile.getSubtitle());
                    data.put("tech", profile.getTech());
                    data.put("photo", profile.getPhotoPath());
                    return ResponseEntity.ok(data);
                })
                .orElseGet(() -> {
                    Map<String, Object> error = new HashMap<>();
                    error.put("error", "profile not found");
                    return ResponseEntity.status(404).body(error);
                });
    }

    // 照片访问接口（直接返回 static 目录下的图片）
    // 无需额外代码，Spring Boot 会自动映射 /static/** 下的静态资源
}
