package com.seasonaldining.store.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "stores")
public class Store {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(nullable = false, length = 100) private String name;
    @Column(name = "store_type", nullable = false, length = 50) private String storeType;
    @Column(name = "logo_url", length = 500) private String logoUrl;
    @Column(name = "logo_text", length = 20) private String logoText;
    @Column(name = "brand_color", length = 30) private String brandColor;
    @Column(name = "external_url", length = 500) private String externalUrl;
    @Column(name = "region_code", length = 50) private String regionCode;
    protected Store() {}
    public Store(String name, String storeType, String logoUrl, String logoText, String brandColor, String externalUrl, String regionCode) {
        this.name = name; this.storeType = storeType; this.logoUrl = logoUrl; this.logoText = logoText; this.brandColor = brandColor; this.externalUrl = externalUrl; this.regionCode = regionCode;
    }
    public Long getId() { return id; }
    public String getName() { return name; }
    public String getStoreType() { return storeType; }
    public String getLogoUrl() { return logoUrl; }
    public String getLogoText() { return logoText; }
    public String getBrandColor() { return brandColor; }
    public String getExternalUrl() { return externalUrl; }
    public String getRegionCode() { return regionCode; }
}
