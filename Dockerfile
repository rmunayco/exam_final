FROM alpine:3.19

RUN apk add --no-cache vsftpd tftp-hpa openssh-server bash


RUN mkdir -p /srv/repo/pub && chmod 777 /srv/repo/pub &&     mkdir -p /var/tftpboot && chmod 777 /var/tftpboot

RUN echo "anonymous_enable=YES" > /etc/vsftpd/vsftpd.conf &&     echo "anon_root=/srv/repo/pub" >> /etc/vsftpd/vsftpd.conf &&     echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf && \ 
    echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf &&     echo "local_root=/srv/repo" >> /etc/vsftpd/vsftpd.conf &&     echo "chroot_local_user=YES" >> /etc/vsftpd/vsftpd.conf &&     echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf &&     echo "listen=YES" >> /etc/vsftpd/vsftpd.conf &&     echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf

RUN ssh-keygen -A &&     adduser -D admin && echo "admin:admin" | chpasswd &&     echo "Macth User admin" >> /etc/ssh/sshd_config &&     echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config &&     echo " ChrootDirectory /srv/repo" >> /etc/ssh/sshd_config

EXPOSE 21 22 69/udp

CMD vsftpd /etc/vsftpd/vsftpd.conf &     /usr/sbin/sshd -D &     in.tftpd --foreground --listen --address 0.0.0.0:69 --secure /var/tftpboot
