-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql212.epizy.com
-- Generation Time: Nov 06, 2021 at 11:12 AM
-- Server version: 5.7.35-38
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `epiz_26598314_job_hunting`
--

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `url` varchar(100) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `street` varchar(255) NOT NULL,
  `city` varchar(30) NOT NULL,
  `postcode` varchar(5) NOT NULL,
  `state` varchar(15) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `name`, `email`, `phone`, `url`, `profile`, `street`, `city`, `postcode`, `state`, `user_id`) VALUES
(3, 'Test Company Sdn Bhd', 'testcompany001@test.com', '071892635', 'https://www.nightcatdigitalsolutions.com/', '1636200911.jpeg', '14, Jalan Tak Pernah Jumpa, Bandar Tak Pernah Wujud', 'Skudai', '12345', 'kuala-lumpur', 2);

-- --------------------------------------------------------

--
-- Table structure for table `job`
--

CREATE TABLE `job` (
  `id` int(10) UNSIGNED NOT NULL,
  `position` varchar(100) NOT NULL,
  `experience` int(2) UNSIGNED NOT NULL,
  `salary` float(7,2) UNSIGNED NOT NULL,
  `description` mediumtext NOT NULL,
  `requirement` mediumtext NOT NULL,
  `postDate` datetime DEFAULT NULL,
  `company_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `job`
--

INSERT INTO `job` (`id`, `position`, `experience`, `salary`, `description`, `requirement`, `postDate`, `company_id`) VALUES
(1, 'Test Job 001', 3, 1500.00, 'Lorem ipsum dolor sit amet consectetur adipiscing elit dui neque, facilisi phasellus ultrices aenean netus ridiculus habitasse ac, dictum quam maecenas eu pharetra hendrerit mollis feugiat. Vivamus litora cubilia vestibulum felis torquent, dictum semper mus dis, morbi cum phasellus imperdiet. Quisque ad proin integer mollis nibh pretium class ultricies condimentum, parturient imperdiet eget aptent in auctor conubia consequat, diam sem ac quis nascetur ut sed etiam.\r\n\r\nCongue convallis quisque ornare vulputate et suscipit quis morbi commodo, facilisi tellus nisl scelerisque lacus sem vitae pellentesque purus, dictum ridiculus magna nullam ligula lectus sagittis phasellus. Etiam ornare sem enim ultrices suspendisse fames metus iaculis, nullam dis sociis augue dictumst laoreet phasellus, interdum risus cum velit fringilla primis in. Sodales mattis malesuada hac per id ridiculus scelerisque porttitor, nascetur nulla a suspendisse volutpat maecenas nisl netus fusce, massa leo ante tempor sagittis ut aliquet.', '- overtime working\r\n- overtime working\r\n- overtime working\r\n- overtime working\r\n- overtime working\r\n- overtime working', '2021-11-06 08:40:35', 3);

-- --------------------------------------------------------

--
-- Table structure for table `savedjob`
--

CREATE TABLE `savedjob` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `job_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` varchar(8) NOT NULL,
  `password` varchar(100) NOT NULL,
  `token` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `username`, `email`, `role`, `password`, `token`) VALUES
(2, 'Tester Test 001', 'tester001', 'tester001@test.com', 'employer', 'y2PcWHPEFh3xXhj7E6ErgA==', ''),
(3, 'Tester Test 003', 'tester003', 'tester003@test.com', 'employee', 'y2PcWHPEFh3xXhj7E6ErgA==', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_UserCompany` (`user_id`);

--
-- Indexes for table `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_CompanyJob` (`company_id`);

--
-- Indexes for table `savedjob`
--
ALTER TABLE `savedjob`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `FK_JobSavedJob` (`job_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `job`
--
ALTER TABLE `job`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
