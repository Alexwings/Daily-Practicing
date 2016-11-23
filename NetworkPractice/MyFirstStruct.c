struct addrinfo {
	int ai_flags;
	int ai_family;
	int ai_socktype;
	int ai_protocol;
	size_t ai_addrlen;
	struct sockaddr *ai_addr;
	char *ai_canonname;

	struct addrinfo *ai_next;
}

struct sockaddr {
	unsigned short sa_family;	//address family, AF_xxx
	char sa_data[14];		//14 bytes of protocol address(IP address and port
}

struct sockaddr_in {
	short int sin_family;		//Address Family, AF_INET
	unsigned short int sin_port;	//Prot number
	struct in_addr sin_addr;	//Internet address
	unsigned char sin_zero[8];	//Same size ad struct sockaddr
}

