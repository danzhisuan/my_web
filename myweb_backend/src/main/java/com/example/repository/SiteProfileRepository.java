package com.example.repository;

import com.example.entity.SiteProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SiteProfileRepository extends JpaRepository<SiteProfile, Long> {

    /**
     * 获取档案表中的第一条记录（个人网站目前只维护一份档案）。
     */
    Optional<SiteProfile> findFirstByOrderByIdAsc();
}
