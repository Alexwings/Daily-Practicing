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
struct in_addr {
	uint32_t s_addr;		//that's a 32-bit int
};
struct sockaddr_in6 {
	u_int16_t	sin6_family;	//address family, AF_INET6
	u_int16_t	sin6_port;	//port number, Network Byte Order
	u_int32_t	sin6_addr;	// IPv6 address;
	struct in6_addr	sin6_addr;	//IPv6 address;
	u_int32_t	sin6_scope_id;	//Scope ID
};

