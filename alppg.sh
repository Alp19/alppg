#!/bin/bash
echo -e "\033[0;31m----------------------------------------------------------\033[0m"
echo -e "\033[0;35mAlp Random Password Generator - Alp Rasgele Şifre Oluşturucu\033[0m"
echo -e "\033[0;31m----------------------------------------------------------\033[0m"
echo -e "\033[0;36mGitHub: https://github.com/Alp19 - @Alp19\033[0m"
echo -e "\033[0;31m----------------------------------------------------------\033[0m"

hash_command=""
case $(uname -s) in
    Darwin* )
        hash_command="shasum -a 256"  # macOS
        ;;
    Linux* )
        hash_command="sha256sum"  # Linux
        ;;
    FreeBSD* )
        hash_command="sha256"  # FreeBSD
        ;;
    * )
        echo "Bu işletim sistemi desteklenmiyor. - This operating system is not supported :("
        exit 1
        ;;
esac

echo "Hash algoritmasını seçin - Choose the hash algorithm"
select algorithm in "SHA-256" "MD5" "SHA-1" "RIPEMD160" "Whirlpool"; do
    case $algorithm in
        "SHA-256" )
            hash_function="$hash_command"
            break
            ;;
        "MD5" )
            hash_function="md5sum"
            break
            ;;
        "SHA-1" )
            hash_function="sha1sum"
            break
            ;;
        "RIPEMD160" )
            hash_function="ripemd160sum"
            break
            ;;
        "Whirlpool" )
            hash_function="$hash_command -a 512"
            break
            ;;
        * )
            echo "Geçersiz seçim, tekrar deneyin - Invalid selection, try again."
            ;;
    esac
done

read -p "Parola uzunluğunu girin - Enter password length: " length

if ! [[ "$length" =~ ^[0-9]+$ ]]; then
    echo "Hatalı giriş! Lütfen bir sayı girin - Invalid input! Please enter a number."
    exit 1
fi

echo "Şifre türünü seçin - Choose password type"
select type in "Yalnızca Harf ve Rakam - Letters and Numbers Only" "Harf, Rakam ve Özel Karakterler - Letters, Numbers and Special Characters"; do
    case $type in
        "Yalnızca Harf ve Rakam - Letters and Numbers Only" )
            character_set="A-Za-z0-9"
            break
            ;;
        "Harf, Rakam ve Özel Karakterler - Letters, Numbers and Special Characters" )
            character_set="A-Za-z0-9\!\@\#\$\%\^\&\*"
            break
            ;;
        * )
            echo "Geçersiz seçim, tekrar deneyin - Invalid selection, try again."
            ;;
    esac
done

password=$(LC_CTYPE=C tr -dc "$character_set" < /dev/urandom | head -c "$length")

hashed_password=$(echo -n "$password" | $hash_function | cut -d' ' -f1)
echo "Oluşturulan Rastgele Parola - Random Password Generated : $password"
echo "Hashlenmiş Parola - Hashed Password ($algorithm): $hashed_password"
