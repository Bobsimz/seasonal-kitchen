package com.seasonaldining.user.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "user_addresses")
public class UserAddress {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "recipient_name", nullable = false, length = 50)
    private String recipientName;
    @Column(nullable = false, length = 30)
    private String phone;
    @Column(name = "zip_code", length = 10)
    private String zipCode;
    @Column(nullable = false, length = 200)
    private String address1;
    @Column(length = 200)
    private String address2;
    @Column(name = "is_default", nullable = false)
    private boolean isDefault = false;
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    protected UserAddress() {}

    public UserAddress(Long userId, String recipientName, String phone, String zipCode,
                       String address1, String address2, boolean isDefault) {
        this.userId = userId;
        this.recipientName = recipientName;
        this.phone = phone;
        this.zipCode = zipCode;
        this.address1 = address1;
        this.address2 = address2;
        this.isDefault = isDefault;
        this.createdAt = OffsetDateTime.now();
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getRecipientName() { return recipientName; }
    public String getPhone() { return phone; }
    public String getZipCode() { return zipCode; }
    public String getAddress1() { return address1; }
    public String getAddress2() { return address2; }
    public boolean isDefault() { return isDefault; }
    public OffsetDateTime getCreatedAt() { return createdAt; }

    public void changeRecipientName(String v) { if (v != null) this.recipientName = v; }
    public void changePhone(String v) { if (v != null) this.phone = v; }
    public void changeZipCode(String v) { if (v != null) this.zipCode = v; }
    public void changeAddress1(String v) { if (v != null) this.address1 = v; }
    public void changeAddress2(String v) { if (v != null) this.address2 = v; }
    public void markDefault(boolean v) { this.isDefault = v; }
}
