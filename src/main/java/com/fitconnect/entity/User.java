package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "User")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(unique = true, nullable = false, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Rol rol;

    // Campos específicos de Cliente
    @Column(precision = 5, scale = 2)
    private BigDecimal altura;

    @Column(columnDefinition = "TEXT")
    private String objetivo;

    @Column(name = "fecha_inicio")
    private LocalDate fechaInicio;

    // Campos específicos de Entrenador
    @Column(length = 100)
    private String especialidad;

    @Column(columnDefinition = "TEXT")
    private String biografia;

    @Column(precision = 3, scale = 2)
    private BigDecimal valoracion;

    // ---- Enum de roles ----
    public enum Rol {
        cliente, entrenador, admin
    }

    // ---- UserDetails (Spring Security) ----
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + rol.name().toUpperCase()));
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }

    @PrePersist
    public void prePersist() {
        if (fechaRegistro == null) fechaRegistro = LocalDateTime.now();
    }
}
