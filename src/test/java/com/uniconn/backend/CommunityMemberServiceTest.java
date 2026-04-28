package com.uniconn.backend;

import com.uniconn.backend.composite_keys.CommunityMemberId;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.*;
import com.uniconn.backend.services.BaseService;
import com.uniconn.backend.services.CommunityMemberService;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CommunityMemberServiceTest {

    @Mock private CommunityMemberRepository communityMemberRepository;
    @Mock private CommunityRepository communityRepository;
    @Mock private UserRepository userRepository;

    private CommunityMemberService communityMemberService;

    private User mockUser;
    private Community mockCommunity;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        // Manually construct service so all constructor args are injected
        communityMemberService = new CommunityMemberService(
            communityMemberRepository, communityRepository
        );

        // Inject userRepository into BaseService parent field (not reached by constructor)
        try {
            java.lang.reflect.Field repoField = BaseService.class.getDeclaredField("userRepository");
            repoField.setAccessible(true);
            repoField.set(communityMemberService, userRepository);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Build mockUser
        mockUser = new User();
        mockUser.setUsername("daria");
        mockUser.setCommunityCount(2);

        // Force-set auto-generated userId via reflection
        try {
            java.lang.reflect.Field userIdField = User.class.getDeclaredField("userId");
            userIdField.setAccessible(true);
            userIdField.set(mockUser, 1);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Pass mockUser as principal so (User) cast in BaseService works
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken(mockUser, null, java.util.List.of())
        );

        // BaseService.getAuthenticatedUser() calls findById
        when(userRepository.findById(1)).thenReturn(Optional.of(mockUser));

        // Build mockCommunity
        mockCommunity = new Community();
        mockCommunity.setMemberCount(5);

        // Force-set auto-generated communityId via reflection
        try {
            java.lang.reflect.Field communityIdField = Community.class.getDeclaredField("communityId");
            communityIdField.setAccessible(true);
            communityIdField.set(mockCommunity, 10);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        when(communityRepository.findById(10)).thenReturn(Optional.of(mockCommunity));
    }

    // --- joinCommunity tests ---

    @Test
    void joinCommunity_success() {
        CommunityMemberId memberId = new CommunityMemberId(10, 1);
        when(communityMemberRepository.existsById(memberId)).thenReturn(false);

        String result = communityMemberService.joinCommunity(10);

        assertEquals("Joined community successfully!", result);
        assertEquals(6, mockCommunity.getMemberCount());   // 5 + 1
        assertEquals(3, mockUser.getCommunityCount());     // 2 + 1
        verify(communityMemberRepository).save(any(CommunityMember.class));
    }

    @Test
    void joinCommunity_alreadyMember_throwsException() {
        CommunityMemberId memberId = new CommunityMemberId(10, 1);
        when(communityMemberRepository.existsById(memberId)).thenReturn(true);

        RuntimeException ex = assertThrows(RuntimeException.class,
            () -> communityMemberService.joinCommunity(10));

        assertEquals("Already a member of this community", ex.getMessage());
    }

    // --- leaveCommunity tests ---

    @Test
    void leaveCommunity_success() {
        CommunityMemberId memberId = new CommunityMemberId(10, 1);
        when(communityMemberRepository.existsById(memberId)).thenReturn(true);

        String result = communityMemberService.leaveCommunity(10);

        assertEquals("Left community successfully", result);
        assertEquals(4, mockCommunity.getMemberCount());   // 5 - 1
        assertEquals(1, mockUser.getCommunityCount());     // 2 - 1
        verify(communityMemberRepository).deleteById(memberId);
    }

    @Test
    void leaveCommunity_notMember_throwsException() {
        CommunityMemberId memberId = new CommunityMemberId(10, 1);
        when(communityMemberRepository.existsById(memberId)).thenReturn(false);

        RuntimeException ex = assertThrows(RuntimeException.class,
            () -> communityMemberService.leaveCommunity(10));

        assertEquals("You are not a member of this community", ex.getMessage());
    }

    @Test
    void leaveCommunity_countNeverGoesBelowZero() {
        mockCommunity.setMemberCount(0);
        mockUser.setCommunityCount(0);

        CommunityMemberId memberId = new CommunityMemberId(10, 1);
        when(communityMemberRepository.existsById(memberId)).thenReturn(true);

        communityMemberService.leaveCommunity(10);

        assertEquals(0, mockCommunity.getMemberCount());  // Math.max(0, ...) guard
        assertEquals(0, mockUser.getCommunityCount());
    }
}